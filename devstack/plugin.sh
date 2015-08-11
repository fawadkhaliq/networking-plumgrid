#!/bin/bash

# Save trace settings
PG_XTRACE=$(set +o | grep xtrace)
set +o xtrace

function neutron_plugin_create_nova_conf {
    :
}

function neutron_plugin_setup_interface_driver {
    :
}

function configure_plumgrid_plugin {
    echo "Configuring Neutron for PLUMgrid"

    if is_service_enabled q-svc ; then
        Q_PLUGIN_CLASS="neutron.plugins.plumgrid.plumgrid_plugin.plumgrid_plugin.NeutronPluginPLUMgridV2"

        NEUTRON_CONF=/etc/neutron/neutron.conf
        iniset $NEUTRON_CONF DEFAULT core_plugin "$Q_PLUGIN_CLASS"
        iniset $NEUTRON_CONF DEFAULT service_plugins ""
    fi
}

function neutron_plugin_configure_debug_command {
    :
}

function is_neutron_ovs_base_plugin {
    # False
    return 1
}

function has_neutron_plugin_security_group {
    # return 0 means enabled
    return 0
}

function neutron_plugin_check_adv_test_requirements {
    is_service_enabled q-agt && is_service_enabled q-dhcp && return 0
}

if [[ "$1" == "stack" && "$2" == "pre-install" ]]; then
    # Set up system services
    echo_summary "Configuring system services Template"

elif [[ "$1" == "stack" && "$2" == "install" ]]; then
    # Perform installation of service source
    echo_summary "Installing Template"
    configure_plumgrid_plugin 

elif [[ "$1" == "stack" && "$2" == "post-config" ]]; then
    # Configure after the other layer 1 and 2 services have been configured
    echo_summary "Configuring Template"

elif [[ "$1" == "stack" && "$2" == "extra" ]]; then
    # Initialize and start the template service
    echo_summary "Initializing Template"
    init_template
fi

if [[ "$1" == "unstack" ]]; then
    echo "networking-plumgrid unstack"
    # no-op
        :
fi

if [[ "$1" == "clean" ]]; then
    echo_summary "networking-plumgrid clean"
    # no-op
        :
fi
# Restore xtrace
$PG_XTRACE
