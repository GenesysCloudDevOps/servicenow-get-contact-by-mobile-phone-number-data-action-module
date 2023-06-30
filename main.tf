resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "$schema": "http://json-schema.org/draft-04/schema#",
        "description": "Test Action for Developer ServiceNow. Find UserID record based on mobile_phone field",
        "properties": {
            "Domain": {
                "description": "The Service Now instance domain e.g. https://*domain*.service-now.com",
                "type": "string"
            },
            "PHONE_NUMBER": {
                "description": "CustomLookUpValue",
                "type": "string"
            }
        },
        "required": [
            "PHONE_NUMBER"
        ],
        "title": "Developer ServiceNow",
        "type": "object"
    })
    contract_output = jsonencode({
        "$schema": "http://json-schema.org/draft-04/schema#",
        "description": "Service Now Response. UserID",
        "properties": {
            "SYSID": {
                "type": "string"
            },
            "length": {
                "type": "integer"
            }
        },
        "title": "Service Now Response",
        "type": "object"
    })
    
    config_request {
        request_template     = "{}"
        request_type         = "GET"
        request_url_template = "https://$${input.Domain}.service-now.com/api/now/table/sys_user?mobile_phone=$esc.url($input.PHONE_NUMBER)"
        
    }

    config_response {
        success_template = "{\r\n\"SYSID\": $${SYSID},\r\n\"length\": $${length}\r\n}"
        translation_map = { 
			length = "$.result.length()"
			SYSID = "$.result[0].sys_id"
		}
               
    }
}