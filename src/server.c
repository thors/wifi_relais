#include "osapi.h"
#include "mem.h"
#include "ets_sys.h"
#include "ip_addr.h"
#include "espconn.h"
#include "user_interface.h"

struct espconn *pHTTPServer;
void ICACHE_FLASH_ATTR server_connect_cb(void *arg);
void ICACHE_FLASH_ATTR server_received_cb(void *arg, char *pdata, unsigned short len);
void ICACHE_FLASH_ATTR server_disconnect_cb(void *arg);
void ICACHE_FLASH_ATTR server_sent_cb(void *arg);

void initServer() {
  //Allocate an "espconn"
  pHTTPServer = (struct espconn *)os_zalloc(sizeof(struct espconn));
  ets_memset( pHTTPServer, 0, sizeof( struct espconn ) );

  //Initialize the ESPConn
  espconn_create( pHTTPServer );
  pHTTPServer->type = ESPCONN_TCP;
  pHTTPServer->state = ESPCONN_NONE;

  //Make it a TCP conention.
  pHTTPServer->proto.tcp = (esp_tcp *)os_zalloc(sizeof(esp_tcp));
  pHTTPServer->proto.tcp->local_port = 80;

  //"httpserver_connectcb" gets called whenever you get an incoming connetion.
  espconn_regist_connectcb(pHTTPServer, server_connect_cb);
  
  //Start listening!
  espconn_accept(pHTTPServer);

  //I don't know what default is, but I always set this.
  espconn_regist_time(pHTTPServer, 15, 0);
}

//This function gets called whenever a client connects
void ICACHE_FLASH_ATTR server_connect_cb(void *arg) {
    struct espconn *pespconn = (struct espconn *)arg;
    //espconn's have a extra flag you can associate extra information with a connection.
    pespconn->reverse = pHTTPServer;
    //Let's register a few callbacks, for when data is received or a disconnect happens.
    espconn_regist_recvcb( pespconn, server_received_cb );
    espconn_regist_disconcb( pespconn, server_disconnect_cb );
}

void ICACHE_FLASH_ATTR server_received_cb(void *arg, char *pdata, unsigned short len) {
}

void ICACHE_FLASH_ATTR server_disconnect_cb(void *arg) {
}

void ICACHE_FLASH_ATTR server_sent_cb(void *arg) {
}
