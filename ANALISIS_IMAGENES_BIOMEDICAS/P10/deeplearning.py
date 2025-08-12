#!/usr/bin/env python
# coding: utf-8

import platform

if platform.system() == 'Darwin':
    import matplotlib
    matplotlib.use('MACOSX')

import matplotlib.pyplot as plt
import cv2
import torch
import torch.nn as nn

import torch.utils.data as data
import torchvision.transforms as transforms
import os
import glob
import numpy as np
import random
from time import process_time
import sys


# Definir hiperparámetros
BATCH_SIZE = 2
LR = 0.0001
N_INPUT_CHANNELS = 1
N_CLASSES = 1
NEPOCHS = 30
THRESHOLD = 0.5

# Función auxiliar para mostrar a la vez una imagen
# y una máscara
def show(image, mask, title=None):
    fig, ax = plt.subplots(1,2)
    ax[0].imshow(image, cmap="gray")
    ax[0].axis('off')
    if title is not None:
        fig.suptitle(title)

    ax[1].imshow(mask, cmap="gray")
    ax[1].axis('off')
    plt.show()
    


def double_conv(in_channels, out_channels):
    return nn.Sequential(
        nn.Conv2d(in_channels, out_channels, 3, padding=1),
        nn.ReLU(inplace=True),
        nn.Conv2d(out_channels, out_channels, 3, padding=1),
        nn.ReLU(inplace=True)
    )   


class UNet(nn.Module):

    def __init__(self, input_channels, n_class):
        super().__init__()
                
        self.dconv_down1 = double_conv(input_channels, 64)
        self.dconv_down2 = double_conv(64, 128)
        self.dconv_down3 = double_conv(128, 256)
        self.dconv_down4 = double_conv(256, 512)        

        self.maxpool = nn.MaxPool2d(2)
        self.upsample = nn.Upsample(scale_factor=2, mode='bilinear', align_corners=True)        
        
        self.dconv_up3 = double_conv(256 + 512, 256)
        self.dconv_up2 = double_conv(128 + 256, 128)
        self.dconv_up1 = double_conv(128 + 64, 64)
        
        self.conv_last = nn.Conv2d(64, n_class, 1)
        
        
    def forward(self, x):
        conv1 = self.dconv_down1(x)
        x = self.maxpool(conv1)

        conv2 = self.dconv_down2(x)
        x = self.maxpool(conv2)
        
        conv3 = self.dconv_down3(x)
        x = self.maxpool(conv3)   
        
        x = self.dconv_down4(x)
        
        x = self.upsample(x)        
        x = torch.cat([x, conv3], dim=1)
        
        x = self.dconv_up3(x)
        x = self.upsample(x)        
        x = torch.cat([x, conv2], dim=1)       

        x = self.dconv_up2(x)
        x = self.upsample(x)        
        x = torch.cat([x, conv1], dim=1)   
        
        x = self.dconv_up1(x)
        
        out = self.conv_last(x)
        
        return out



class EmbryoDataset(data.Dataset):
    
    def __init__(self, image_path, mask_path, transform = None):
        super().__init__()
        # Cargar los nombres de fichero de todas las imágenes
        self.img_files = glob.glob(os.path.join(image_path,'*.tif'))
        self.mask_files = []
        # Cargar los nombres de fichero de las máscaras (se asume cada
        # máscara tiene el mismo nombre que la imagen correspondiente)
        
        for img_path in self.img_files:
             self.mask_files.append(os.path.join(mask_path,os.path.basename(img_path)))
                
        self.transform = transform

    # Devuelve la n-ésima imagen con su máscara correspondiente 
    def __getitem__(self, index):
            img_path = self.img_files[index]
            mask_path = self.mask_files[index]
            image = cv2.imread(img_path, cv2.IMREAD_GRAYSCALE)
            mask = cv2.imread(mask_path, cv2.IMREAD_GRAYSCALE)
            
            if self.transform is not None:
                seed = np.random.randint(2147483647) # make a seed with numpy generator 
                random.seed(seed) # apply this seed to img tranfsorms
                torch.manual_seed(seed) 
                image = self.transform(image)
                random.seed(seed) # apply this seed to img tranfsorms
                torch.manual_seed(seed) 
                mask = self.transform(mask)
            else:
                t2 = transforms.Compose([ 
                        transforms.ToPILImage(),
                        transforms.ToTensor()])
                image = t2(image)
                mask = t2(mask)
        
                
            return image, mask

    def __len__(self):
        return len(self.img_files)

# Función auxiliar para convertir un tensor de torch en una matriz numpy
def tensor_to_image(tensor):
    new_image = np.empty( (tensor.size()[1], tensor.size()[2]) )
    new_image[:,:] = tensor[0,:,:].cpu() if torch.cuda.is_available() else tensor[0,:,:]
    return new_image

# Función de entrenamiento
def train(net, train_loader, test_loader, criterion, optimizer, nepochs=10):
    
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    
    net = net.to(device)
    
    train_steps = len(train_loader)
    test_steps = len(test_loader)
    best_loss = 9999999
    
    for epoch in range(nepochs):  # loop over the dataset multiple times
        t1_start = process_time()


        net.train() # Modo entrenamiento
        total_train_loss = 0
        total_test_loss = 0
        
        
        for i, data in enumerate(train_loader, 0):
            #print(f"[Training] {epoch} - {i}")
            # get the inputs; data is a list of [inputs, labels]
            inputs, masks = data
            inputs = inputs.to(device)
            masks = masks.to(device)

            # zero the parameter gradients
            optimizer.zero_grad()

            # forward + backward + optimize
            outputs = net(inputs)
            loss = criterion(outputs, masks)
            loss.backward()
            optimizer.step()

            # print statistics
            total_train_loss += loss.item()
            
        with torch.no_grad():
            net.eval()
            for (inputs, masks) in test_loader:
                inputs = inputs.to(device)
                masks = masks.to(device)
                outputs = net(inputs)
                total_test_loss += criterion(outputs, masks)
        avg_test_loss = total_test_loss/test_steps
        if  avg_test_loss < best_loss:
            best_loss =  avg_test_loss
            torch.save(unet, 'unet-best.pth') 

        t1_stop = process_time()
        print(f"[INFO] EPOCH {epoch}/{nepochs} Train loss: {total_train_loss/train_steps} Test loss: {total_test_loss/test_steps}. Elapsed time: {t1_stop-t1_start}s")
    print('Finished Training. Saving final model...')
    torch.save(unet, 'unet-final.pth')

                
def predict(net, image, threshold=0.5):
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    net.eval()
    with torch.no_grad():
        image = image.to(device)
        output = net(image)
        prob = torch.sigmoid(output)
        prediction = tensor_to_image(prob[0,:,:,:].detach().cpu()>threshold)
        return prediction


if __name__ == "__main__":

    train_model = False
    if len(sys.argv) == 2:
        train_model = (sys.argv[1] == "-t")


    # Cargar imágenes del dataset sin data augmentation

    simple_dataset = EmbryoDataset("res/unet/images", "res/unet/masks")

    # Cargar imágenes con data augmentation
    transf = transforms.Compose([
        transforms.ToPILImage(),
        transforms.RandomHorizontalFlip(),
        transforms.RandomVerticalFlip(),
        transforms.RandomRotation(5),
        transforms.CenterCrop(400), # Evitar zonas negras tras rotar imagen
        transforms.ToTensor()
    ])


    augmented_dataset = EmbryoDataset("res/unet/images", "res/unet/masks", transf)
    
    train_set, test_set = torch.utils.data.random_split(simple_dataset, [12, 3])





    # Iteradores sobre los conjuntos de entrenamiento y prueba
    train_loader = torch.utils.data.DataLoader(train_set, batch_size=BATCH_SIZE,
                                          shuffle=True, num_workers=4)
    test_loader = torch.utils.data.DataLoader(test_set, batch_size=BATCH_SIZE,
                                         shuffle=False, num_workers=4)

    # Red
    unet = UNet(N_INPUT_CHANNELS,N_CLASSES)


    # Métrica a minimizar
    bce_loss = nn.BCEWithLogitsLoss()

    # Algoritmo de minimización
    adam_optimizer = torch.optim.Adam(unet.parameters(), lr=LR)

    if train_model:
        train(unet, train_loader, test_loader, bce_loss, adam_optimizer, NEPOCHS)
    
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

    best_model = torch.load('unet-best.pth', map_location=device)

    
    for im, mask in test_set:
        im = im[None, :,:,:]
        prediction = predict(best_model, im)
        show(tensor_to_image(im[0,:,:,:])*prediction, tensor_to_image(im[0,:,:,:])*tensor_to_image(mask), title="Resultados en conjunto de test")
    