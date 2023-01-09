#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <termios.h>

#define DEV_NAME "/dev/cu.wchusbserial1440"
#define BAUD_RATE B115200

#define OFFLIST_LEN 2
float offList[OFFLIST_LEN][2] = {
  {4.0, 2.0},
  {7.5, 12.0}
};

void sendHaptic(int fd) {
  static float x, y;
  char buf[100];
  
  id pool = [[NSAutoreleasePool alloc] init];

  NSCursor *c = [NSCursor currentSystemCursor];
  NSPoint p = [c hotSpot];
  if(x != p.x || y != p.y) {
    printf("%f, %f\n", p.x, p.y);
    x = p.x;
    y = p.y;
    for(int i = 0; i < OFFLIST_LEN; i++) {
      if(x == offList[i][0] && y == offList[i][1]) {
	buf[0] = '0';
	if(write(fd, buf, 1) < 0) {
	  printf("disconnected.\n");
	  exit(-1);
	}
	return;
      }	
    }
    buf[0] = '1';
    if(write(fd, buf, 1) < 0) {
      printf("disconnected.\n");
      exit(-1);
    }
  }

  [pool release];
}

void serial_init(int fd) {
  struct termios t;

  memset(&t, 0, sizeof(t));
  t.c_cflag = CS8 | CLOCAL | CREAD;
  t.c_cc[VTIME] = 100;
  cfsetispeed(&t, BAUD_RATE);
  cfsetospeed(&t, BAUD_RATE);
  tcsetattr(fd, TCSANOW, &t);
}

int main(int argc, const char * argv[]) {
  int serial_fd;
  
  serial_fd = open(DEV_NAME, O_RDWR | O_NONBLOCK );
  if(serial_fd < 0) {
    printf("Fail to open the serial port %s\n", DEV_NAME);
    exit(1);
  }
  serial_init(serial_fd);
  
  for(;;) {
    sendHaptic(serial_fd);
  }

  return 0;
}
