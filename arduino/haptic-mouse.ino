#define SOLENOID_PIN 4

void setup() {
  pinMode(SOLENOID_PIN, OUTPUT);
  Serial.begin(115200);
}

long int ontime;

void loop() {
//  if(ontime + 1000 < millis()) {
//    digitalWrite(SOLENOID_PIN, LOW);
//  }
  int val = Serial.read();
  if(val < 0)
    return;
  if(val == '1') {
    digitalWrite(SOLENOID_PIN, HIGH);
    ontime = millis();
  }
  else if(val == '0') {
    digitalWrite(SOLENOID_PIN, LOW);
  }
}
