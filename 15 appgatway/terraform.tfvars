
       gatewayname="appgateway"
        resource_group_name="kadir-resources"
        location="West Europe"
         virtual_network_name="kadirvnet"
         subnet="kadirlbsubnet"
         ipname= "loadbalancerpip"

         frontend_port_name = "fport"
         frontend_ip_configuration_name = "fipcon"
         backend_address_pool_name = "bpool"
         backend_http_settings_name = "bsettingname"
         http_listener_name = "listener1"
         request_routing_rule_name = "routingrule1"
         


appgatewayassociation = {
    appgatewayassociation1={
       network_interface_name="frontendnic1"
        resource_group_name="kadir-resources"
    }
    appgatewayassociation2={
       network_interface_name="frontendnic2"
               resource_group_name="kadir-resources"
    }
}

