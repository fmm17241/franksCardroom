# -*- coding: utf-8 -*-
"""
Created on Mon Jun  3 19:04:32 2024

@author: fmm17241
"""
#pip install librosa 
import os
import librosa
import librosa.display
#import iPython.display as ipd
import numpy as np
import matplotlib.pyplot as plt

os.chdir(r"C:\Users\fmm17241\OneDrive - University of Georgia\data\audioFiles")
         
taunt_file = 'taunt.wav'
cantina_file = 'cantina.wav'
reef_file = 'sanctSound.wav'
march_file = 'march.wav'
tswift_file = 'tswift.wav'

taunt, sr = librosa.load(taunt_file)
cantina, _ = librosa.load(cantina_file)
reef, _ = librosa.load(reef_file)
march, _ = librosa.load(march_file)
tswift, _ = librosa.load(tswift_file)

frame_size = 2048
hop_size = 512

s_scale = librosa.stft(march, n_fft=frame_size, hop_length=hop_size)

s_scale.shape

type(s_scale[0][0])

#Moving from FT to spectrogram, square magnitude
y_scale = np.abs(s_scale) ** 2
y_scale.shape
type(y_scale[0][0])

def plot_spectrogram(Y, sr, hop_length, y_axis='linear'):
    plt.figure(figsize=(25,10))
    librosa.display.specshow(Y, sr=sr, hop_length = hop_length, x_axis="time", y_axis = y_axis)
    plt.colorbar(format="%+2.f")
    
    
plot_spectrogram(y_scale, sr, hop_size)



###
#Log-Amplitude Spectrogram
y_log_scale = librosa.power_to_db(y_scale)
plot_spectrogram(y_log_scale, sr, hop_size)
plt.tile('Imperial March')


s_taunt  = librosa.stft(taunt, n_fft=frame_size, hop_length=hop_size)
s_reef   = librosa.stft(reef, n_fft=frame_size, hop_length=hop_size)
s_tswift = librosa.stft(tswift, n_fft=frame_size, hop_length=hop_size)
s_cantina = librosa.stft(cantina, n_fft=frame_size, hop_length=hop_size)

y_march = librosa.power_to_db(np.abs(s_scale) ** 2)
y_taunt = librosa.power_to_db(np.abs(s_taunt) ** 2 )
y_reef = librosa.power_to_db(np.abs(s_reef) ** 2)
y_tswift = librosa.power_to_db(np.abs(s_tswift) ** 2 )
y_cantina = librosa.power_to_db(np.abs(s_cantina) ** 2 ) 


plot_spectrogram(y_march, sr, hop_size, y_axis = "log")
plt.title('Spectrogram: Imperial March')


plot_spectrogram(y_taunt, sr, hop_size, y_axis = "log")
plt.title('French Taunter')


plot_spectrogram(y_reef, sr, hop_size, y_axis = "log")
plt.title('Grays Reef Soundscape')























