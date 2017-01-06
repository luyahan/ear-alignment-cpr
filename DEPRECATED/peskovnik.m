function peskovnik()
    imgSetVector = imageSet('piotr-cpr/faces/ban_ki-moon-1444077119755/');

   img = read(imgSetVector(1), 3);
 
    result = img;
    save('faces_images.mat', 'result');
end

