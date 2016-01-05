/*
  - Connect to wifi as client (username/password hardcoded)
  - Listen for http request
  - Start timer
 */


#include "osapi.h"
#include "ets_sys.h"
#include "user_interface.h"
#include "server.h"

int time_counter; 
ETSTimer pTimer;

typedef struct {
  int i;
} timer_data_s;

timer_data_s timer_data;

void timer_fnc(void *data) {
  time_counter++;
}

void connectNode() {
  const char ssid[32] = WIFI_SSID;
  const char password[32] = WIFI_PASSWD;

  struct station_config stationConf;

  wifi_set_opmode( STATION_MODE );
  os_memcpy(&stationConf.ssid, ssid, 32);
  os_memcpy(&stationConf.password, password, 32);
  wifi_station_set_config(&stationConf);
  wifi_station_connect();
}

void user_init(void) {
  time_counter = 0;
  os_printf("Connect node\n");
  connectNode();
  os_printf("Connected node\n");
  //initServer();
  //os_timer_setfn(&pTimer, &timer_fnc, &timer_data);
}
