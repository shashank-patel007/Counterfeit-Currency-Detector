from django.shortcuts import render
from django.core.files.base import ContentFile
from rest_framework.views import APIView
from rest_framework.response import Response
import tensorflow as tf
import os
import cv2
import numpy as np
import base64
from PIL import Image
import io 

class Home(APIView):
    model = None
    def model_2000(self,request):
        self.model = tf.keras.models.load_model(r'C:\Users\Shashank Patel\Desktop\College\SEM5\Minor Project\data\train\model.h5')
        b = request.FILES['file'].read()
        img = Image.open(io.BytesIO(b))
        img_np = np.array(img)
        img_np = cv2.resize(img_np,(204,100))
        print(img_np.shape)
        pred = self.model.predict(img_np.reshape(1,100,204,3))
        print(np.round(pred))
        return Response({'prediction':str(int(np.round(pred)))})
    def model_500(self,request):
        self.model = tf.keras.models.load_model(r'C:\Users\Shashank Patel\Desktop\College\SEM5\Minor Project\data\train\own_500.h5')
        b = request.FILES['file'].read()
        img = Image.open(io.BytesIO(b))
        img_np = np.array(img)
        img_np = cv2.resize(img_np,(224,224))
        print(img_np.shape)
        pred = self.model.predict(img_np.reshape(1,224,224,3))
        print(np.argmax(pred[0],axis=0))
        if np.argmax(pred[0],axis=0)==0:
            return Response({'prediction':'0'})    
        else:
            return Response({'prediction':'1'})    
    def post(self,request):
        data = request.data
        response = None
        if data['flag']=='0':
            response=self.model_2000(request)
        elif data['flag']=='1':
            response=self.model_500(request)
        return response
        
    def get(self,request):
        pass