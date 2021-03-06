#   Copyright 2018 BigBitBus Inc. http://bigbitbus.com
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.



# Create virtual machine

resource "azurerm_virtual_machine" "_my_azure_vm" {
  name = "aze-${var.instance_type}"
  location = "${var.region}"
  resource_group_name = "${var.resource_group_name}"
  network_interface_ids = ["${var.network_interface_id}"]
  vm_size = "${var.instance_type}"

  storage_os_disk {
    name = "myOsDisk-${var.instance_type}"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # You probably want to parameterize this via variables.
  storage_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "16.04.0-LTS"
    version = "latest"
  }

  os_profile {
    computer_name = "azurehost"
    admin_username = "${var.ssh_user}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path = "/home/${var.ssh_user}/.ssh/authorized_keys"
      key_data = "${var.key_data}"
    }
  }
}


#We will use this to force an implicit dependency so salt module runs after machine completes
output "machineid" {
  value = "${azurerm_virtual_machine._my_azure_vm.id}"
}
