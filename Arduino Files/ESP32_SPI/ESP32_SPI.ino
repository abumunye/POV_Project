#include <SPI.h>

static const int spiClk = 1000000; // 1 MHz

//uninitalised pointers to SPI objects
SPIClass * vspi = NULL;

uint8_t pixel_array[72*3];

void setup() {
  //initialise two instances of the SPIClass attached to VSPI and HSPI respectively
  vspi = new SPIClass(VSPI);
 
  //SCLK = 18, MISO = 19, MOSI = 23, SS = 5
  vspi->begin();
 
  pinMode(5, OUTPUT); //VSPI CS

  pinMode(4, OUTPUT); //Pixel Array DV
  fill_pixel_array(255,0,0);
}

void loop() {
 
  transmit_pixel_array();

}

void transmit_pixel_array(){
  digitalWrite(4,HIGH);
  for(int i=0;i<72*3;i++){
    vspiCommand(pixel_array[i]);
  }
  digitalWrite(4,LOW);
}

void fill_pixel_array(uint8_t red, uint8_t blue, uint8_t green){
  for(int i=0; i<72*3; i+=3){
    pixel_array[i] = red;
    pixel_array[i+1] = blue;
    pixel_array[i+2] = green;
  }
}

void vspiCommand(uint8_t data_to_send) {

  vspi->beginTransaction(SPISettings(spiClk, MSBFIRST, SPI_MODE0));
  digitalWrite(5, HIGH); 
  vspi->transfer(data_to_send);  
  digitalWrite(5, LOW); 
  vspi->endTransaction();
}
