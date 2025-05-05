param($Timer)

# Log the start of the timer-triggered function execution
Write-Output "Starting the PowerShell Timer trigger function at: $(Get-Date)"

#region Variables
$ScimSchemas = @{
    "urn:ietf:params:scim:schemas:core:2.0:User"                 = '{"id":"urn:ietf:params:scim:schemas:core:2.0:User","name":"User","description":"User Account","attributes":[{"name":"userName","type":"string","multiValued":false,"description":"Unique identifier for the User, typically used by the user to directly authenticate to the service provider. Each User MUST include a non-empty userName value.  This identifier MUST be unique across the service provider''s entire set of Users. REQUIRED.","required":true,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"server"},{"name":"name","type":"complex","multiValued":false,"description":"The components of the user''s real name. Providers MAY return just the full name as a single string in the formatted sub-attribute, or they MAY return just the individual component attributes using the other sub-attributes, or they MAY return both.  If both variants are returned, they SHOULD be describing the same name, with the formatted name indicating how the component attributes should be combined.","required":false,"subAttributes":[{"name":"formatted","type":"string","multiValued":false,"description":"The full name, including all middle names, titles, and suffixes as appropriate, formatted for display (e.g., ''Ms. Barbara J Jensen, III'').","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"familyName","type":"string","multiValued":false,"description":"The family name of the User, or last name in most Western languages (e.g., ''Jensen'' given the full name ''Ms. Barbara J Jensen, III'').","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"givenName","type":"string","multiValued":false,"description":"The given name of the User, or first name in most Western languages (e.g., ''Barbara'' given the full name ''Ms. Barbara J Jensen, III'').","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"middleName","type":"string","multiValued":false,"description":"The middle name(s) of the User (e.g., ''Jane'' given the full name ''Ms. Barbara J Jensen, III'').","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"honorificPrefix","type":"string","multiValued":false,"description":"The honorific prefix(es) of the User, or title in most Western languages (e.g., ''Ms.'' given the full name ''Ms. Barbara J Jensen, III'').","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"honorificSuffix","type":"string","multiValued":false,"description":"The honorific suffix(es) of the User, or suffix in most Western languages (e.g., ''III'' given the full name ''Ms. Barbara J Jensen, III'').","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"}],"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"displayName","type":"string","multiValued":false,"description":"The name of the User, suitable for display to end-users.  The name SHOULD be the full name of the User being described, if known.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"nickName","type":"string","multiValued":false,"description":"The casual way to address the user in real life, e.g., ''Bob'' or ''Bobby'' instead of ''Robert''.  This attribute SHOULD NOT be used to represent a User''s username (e.g., ''bjensen'' or ''mpepperidge'').","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"profileUrl","type":"reference","referenceTypes":["external"],"multiValued":false,"description":"A fully qualified URL pointing to a page representing the User''s online profile.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"title","type":"string","multiValued":false,"description":"The user''s title, such as \"Vice President.\"","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"userType","type":"string","multiValued":false,"description":"Used to identify the relationship between the organization and the user.  Typical values used might be ''Contractor'', ''Employee'', ''Intern'', ''Temp'', ''External'', and ''Unknown'', but any value may be used.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"preferredLanguage","type":"string","multiValued":false,"description":"Indicates the User''s preferred written or spoken language.  Generally used for selecting a localized user interface; e.g., ''en_US'' specifies the language English and country US.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"locale","type":"string","multiValued":false,"description":"Used to indicate the User''s default location for purposes of localizing items such as currency, date time format, or numerical representations.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"timezone","type":"string","multiValued":false,"description":"The User''s time zone in the ''Olson'' time zone database format, e.g., ''America/Los_Angeles''.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"active","type":"boolean","multiValued":false,"description":"A Boolean value indicating the User''s administrative status.","required":false,"mutability":"readWrite","returned":"default"},{"name":"password","type":"string","multiValued":false,"description":"The User''s cleartext password.  This attribute is intended to be used as a means to specify an initial password when creating a new User or to reset an existing User''s password.","required":false,"caseExact":false,"mutability":"writeOnly","returned":"never","uniqueness":"none"},{"name":"emails","type":"complex","multiValued":true,"description":"Email addresses for the user.  The value SHOULD be canonicalized by the service provider, e.g., ''bjensen@example.com'' instead of ''bjensen@EXAMPLE.COM''. Canonical type values of ''work'', ''home'', and ''other''.","required":false,"subAttributes":[{"name":"value","type":"string","multiValued":false,"description":"Email addresses for the user.  The value SHOULD be canonicalized by the service provider, e.g., ''bjensen@example.com'' instead of ''bjensen@EXAMPLE.COM''. Canonical type values of ''work'', ''home'', and ''other''.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"display","type":"string","multiValued":false,"description":"A human-readable name, primarily used for display purposes.  READ-ONLY.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"type","type":"string","multiValued":false,"description":"A label indicating the attribute''s function, e.g., ''work'' or ''home''.","required":false,"caseExact":false,"canonicalValues":["work","home","other"],"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"primary","type":"boolean","multiValued":false,"description":"A Boolean value indicating the ''primary'' or preferred attribute value for this attribute, e.g., the preferred mailing address or primary email address.  The primary attribute value ''true'' MUST appear no more than once.","required":false,"mutability":"readWrite","returned":"default"}],"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"phoneNumbers","type":"complex","multiValued":true,"description":"Phone numbers for the User.  The value SHOULD be canonicalized by the service provider according to the format specified in RFC 3966, e.g., ''tel:+1-201-555-0123''. Canonical type values of ''work'', ''home'', ''mobile'', ''fax'', ''pager'', and ''other''.","required":false,"subAttributes":[{"name":"value","type":"string","multiValued":false,"description":"Phone number of the User.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"display","type":"string","multiValued":false,"description":"A human-readable name, primarily used for display purposes.  READ-ONLY.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"type","type":"string","multiValued":false,"description":"A label indicating the attribute''s function, e.g., ''work'', ''home'', ''mobile''.","required":false,"caseExact":false,"canonicalValues":["work","home","mobile","fax","pager","other"],"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"primary","type":"boolean","multiValued":false,"description":"A Boolean value indicating the ''primary'' or preferred attribute value for this attribute, e.g., the preferred phone number or primary phone number.  The primary attribute value ''true'' MUST appear no more than once.","required":false,"mutability":"readWrite","returned":"default"}],"mutability":"readWrite","returned":"default"},{"name":"ims","type":"complex","multiValued":true,"description":"Instant messaging addresses for the User.","required":false,"subAttributes":[{"name":"value","type":"string","multiValued":false,"description":"Instant messaging address for the User.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"display","type":"string","multiValued":false,"description":"A human-readable name, primarily used for display purposes.  READ-ONLY.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"type","type":"string","multiValued":false,"description":"A label indicating the attribute''s function, e.g., ''aim'', ''gtalk'', ''xmpp''.","required":false,"caseExact":false,"canonicalValues":["aim","gtalk","icq","xmpp","msn","skype","qq","yahoo"],"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"primary","type":"boolean","multiValued":false,"description":"A Boolean value indicating the ''primary'' or preferred attribute value for this attribute, e.g., the preferred messenger or primary messenger.  The primary attribute value ''true'' MUST appear no more than once.","required":false,"mutability":"readWrite","returned":"default"}],"mutability":"readWrite","returned":"default"},{"name":"photos","type":"complex","multiValued":true,"description":"URLs of photos of the User.","required":false,"subAttributes":[{"name":"value","type":"reference","referenceTypes":["external"],"multiValued":false,"description":"URL of a photo of the User.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"display","type":"string","multiValued":false,"description":"A human-readable name, primarily used for display purposes.  READ-ONLY.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"type","type":"string","multiValued":false,"description":"A label indicating the attribute''s function, i.e., ''photo'' or ''thumbnail''.","required":false,"caseExact":false,"canonicalValues":["photo","thumbnail"],"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"primary","type":"boolean","multiValued":false,"description":"A Boolean value indicating the ''primary'' or preferred attribute value for this attribute, e.g., the preferred photo or thumbnail.  The primary attribute value ''true'' MUST appear no more than once.","required":false,"mutability":"readWrite","returned":"default"}],"mutability":"readWrite","returned":"default"},{"name":"addresses","type":"complex","multiValued":true,"description":"A physical mailing address for this User. Canonical type values of ''work'', ''home'', and ''other''.  This attribute is a complex type with the following sub-attributes.","required":false,"subAttributes":[{"name":"formatted","type":"string","multiValued":false,"description":"The full mailing address, formatted for display or use with a mailing label.  This attribute MAY contain newlines.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"streetAddress","type":"string","multiValued":false,"description":"The full street address component, which may include house number, street name, P.O. box, and multi-line extended street address information.  This attribute MAY contain newlines.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"locality","type":"string","multiValued":false,"description":"The city or locality component.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"region","type":"string","multiValued":false,"description":"The state or region component.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"postalCode","type":"string","multiValued":false,"description":"The zip code or postal code component.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"country","type":"string","multiValued":false,"description":"The country name component.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"type","type":"string","multiValued":false,"description":"A label indicating the attribute''s function, e.g., ''work'' or ''home''.","required":false,"caseExact":false,"canonicalValues":["work","home","other"],"mutability":"readWrite","returned":"default","uniqueness":"none"}],"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"groups","type":"complex","multiValued":true,"description":"A list of groups to which the user belongs, either through direct membership, through nested groups, or dynamically calculated.","required":false,"subAttributes":[{"name":"value","type":"string","multiValued":false,"description":"The identifier of the User''s group.","required":false,"caseExact":false,"mutability":"readOnly","returned":"default","uniqueness":"none"},{"name":"$ref","type":"reference","referenceTypes":["User","Group"],"multiValued":false,"description":"The URI of the corresponding ''Group'' resource to which the user belongs.","required":false,"caseExact":false,"mutability":"readOnly","returned":"default","uniqueness":"none"},{"name":"display","type":"string","multiValued":false,"description":"A human-readable name, primarily used for display purposes.  READ-ONLY.","required":false,"caseExact":false,"mutability":"readOnly","returned":"default","uniqueness":"none"},{"name":"type","type":"string","multiValued":false,"description":"A label indicating the attribute''s function, e.g., ''direct'' or ''indirect''.","required":false,"caseExact":false,"canonicalValues":["direct","indirect"],"mutability":"readOnly","returned":"default","uniqueness":"none"}],"mutability":"readOnly","returned":"default"},{"name":"entitlements","type":"complex","multiValued":true,"description":"A list of entitlements for the User that represent a thing the User has.","required":false,"subAttributes":[{"name":"value","type":"string","multiValued":false,"description":"The value of an entitlement.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"display","type":"string","multiValued":false,"description":"A human-readable name, primarily used for display purposes.  READ-ONLY.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"type","type":"string","multiValued":false,"description":"A label indicating the attribute''s function.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"primary","type":"boolean","multiValued":false,"description":"A Boolean value indicating the ''primary'' or preferred attribute value for this attribute.  The primary attribute value ''true'' MUST appear no more than once.","required":false,"mutability":"readWrite","returned":"default"}],"mutability":"readWrite","returned":"default"},{"name":"roles","type":"complex","multiValued":true,"description":"A list of roles for the User that collectively represent who the User is, e.g., ''Student'', ''Faculty''.","required":false,"subAttributes":[{"name":"value","type":"string","multiValued":false,"description":"The value of a role.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"display","type":"string","multiValued":false,"description":"A human-readable name, primarily used for display purposes.  READ-ONLY.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"type","type":"string","multiValued":false,"description":"A label indicating the attribute''s function.","required":false,"caseExact":false,"canonicalValues":[],"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"primary","type":"boolean","multiValued":false,"description":"A Boolean value indicating the ''primary'' or preferred attribute value for this attribute.  The primary attribute value ''true'' MUST appear no more than once.","required":false,"mutability":"readWrite","returned":"default"}],"mutability":"readWrite","returned":"default"},{"name":"x509Certificates","type":"complex","multiValued":true,"description":"A list of certificates issued to the User.","required":false,"caseExact":false,"subAttributes":[{"name":"value","type":"binary","multiValued":false,"description":"The value of an X.509 certificate.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"display","type":"string","multiValued":false,"description":"A human-readable name, primarily used for display purposes.  READ-ONLY.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"type","type":"string","multiValued":false,"description":"A label indicating the attribute''s function.","required":false,"caseExact":false,"canonicalValues":[],"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"primary","type":"boolean","multiValued":false,"description":"A Boolean value indicating the ''primary'' or preferred attribute value for this attribute.  The primary attribute value ''true'' MUST appear no more than once.","required":false,"mutability":"readWrite","returned":"default"}],"mutability":"readWrite","returned":"default"}],"meta":{"resourceType":"Schema","location":"/v2/Schemas/urn:ietf:params:scim:schemas:core:2.0:User"}}' | ConvertFrom-Json
    "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User" = '{"id":"urn:ietf:params:scim:schemas:extension:enterprise:2.0:User","name":"EnterpriseUser","description":"Enterprise User","attributes":[{"name":"employeeNumber","type":"string","multiValued":false,"description":"Numeric or alphanumeric identifier assigned to a person, typically based on order of hire or association with anorganization.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"costCenter","type":"string","multiValued":false,"description":"Identifies the name of a cost center.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"organization","type":"string","multiValued":false,"description":"Identifies the name of an organization.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"division","type":"string","multiValued":false,"description":"Identifies the name of a division.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"department","type":"string","multiValued":false,"description":"Identifies the name of a department.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"manager","type":"complex","multiValued":false,"description":"The User''s manager. A complex type that optionally allows service providers to represent organizational hierarchy by referencing the ''id'' attribute of another User.","required":false,"subAttributes":[{"name":"value","type":"string","multiValued":false,"description":"The id of the SCIM resource representingthe User''s manager.  REQUIRED.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"$ref","type":"reference","referenceTypes":["User"],"multiValued":false,"description":"The URI of the SCIM resource representing the User''s manager.  REQUIRED.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"displayName","type":"string","multiValued":false,"description":"The displayName of the User''s manager. OPTIONAL and READ-ONLY.","required":false,"caseExact":false,"mutability":"readOnly","returned":"default","uniqueness":"none"}],"mutability":"readWrite","returned":"default"}],"meta":{"resourceType":"Schema","location":"/v2/Schemas/urn:ietf:params:scim:schemas:extension:enterprise:2.0:User"}}' | ConvertFrom-Json
    "urn:ietf:params:scim:schemas:extension:zoho:2.0:User" = '{"id":"urn:ietf:params:scim:schemas:extension:zoho:2.0:User","name":"ZohoUser","description":"Zoho Additional Properties User","attributes":[[{"name":"Dateofjoining","type":"datetime","multiValued":false,"description":"Datetime of date joining.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"Dateofbirth","type":"string","multiValued":false,"description":"Datetime of birth.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"},{"name":"Dateofexit","type":"datetime","multiValued":false,"description":"Datetime of date exit.","required":false,"caseExact":false,"mutability":"readWrite","returned":"default","uniqueness":"none"}]],"meta":{"resourceType":"Schema","location":"/v2/Schemas/urn:ietf:params:scim:schemas:extension:zoho:2.0:User"}}' | ConvertFrom-Json
}
$AttributeMapping = @{
    externalId   = 'EmployeeID'
    name         = @{
        familyName = 'LastName'
        givenName  = 'FirstName'
    }
    active       = { $_.'Employeestatus' -eq 'Active' }
    userName     = 'EmailID'
    displayName  = 'FullName'
    nickName     = 'EmailID'
    userType     = 'Employee_type'
    title        = 'Job_Title'
    addresses    = @(
        @{
            type          = { 'work' }
            streetAddress = 'Permanent_Address.childValues_ADDRESS1'
            locality      = 'Permanent_Address.childValues_CITY'
            postalCode    = 'Permanent_Address.childValues_PINCODE'
            country       = 'Permanent_Address.childValues_COUNTRY_CODE'
        }
    )
    phoneNumbers = @(
        @{
            type  = { 'work' }
            value = 'OfficePhone'
        }
    )
    "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User" = @{
        employeeNumber = 'EmployeeID'
        costCenter     = 'CostCenter'
        organization   = 'Company'
        division       = 'Business_unit'
        department     = 'Department'
        manager        = @{
            value = 'Reporting_To.MailID'
        }
    }
    "urn:ietf:params:scim:schemas:extension:zoho:2.0:User" = @{
        Dateofbirth    = 'Date_of_birth'
        Dateofjoining     = 'Dateofjoining'
        Dateofexit   = 'Dateofexit'
    }
}
#endregion Variables

#region Functions

function Test-ScimAttributeMapping {
    [CmdletBinding()]
    param (
        # Map input properties to SCIM attributes
        [Parameter(Mandatory = $true)]
        [hashtable] $AttributeMapping,
        # SCIM schema namespace for attribute mapping
        [Parameter(Mandatory = $true)]
        [string] $ScimSchemaNamespace,
        # List of attribute names through sub-attribute names
        [Parameter(Mandatory = $false)]
        [string[]] $HierarchyPath
    )

    ## Initialize
    $result = $true

    foreach ($_PropertyMapping in $AttributeMapping.GetEnumerator()) {

        if ($_PropertyMapping.Key -in 'id', 'externalId') { continue }

        [string[]] $NewHierarchyPath = $HierarchyPath + $_PropertyMapping.Key

        if ($_PropertyMapping.Key -is [string]) {
            if ($_PropertyMapping.Key.StartsWith('urn:')) {
                if ($ScimSchemas.ContainsKey($_PropertyMapping.Key)) {
                    $nestedResult = Test-ScimAttributeMapping $_PropertyMapping.Value $_PropertyMapping.Key
                    $result = $result -and $nestedResult
                }
                else {
                    Write-Warning ('SCIM Schema Namespace [{0}] was not be validated because no schema representation has been defined.' -f $_PropertyMapping.Key)
                }
            }
            elseif ($ScimSchemas.ContainsKey($ScimSchemaNamespace)) {
                $ScimSchemaAttribute = $ScimSchemas[$ScimSchemaNamespace].attributes | Where-Object name -EQ $NewHierarchyPath[0]
                for ($i = 1; $i -lt $NewHierarchyPath.Count; $i++) {
                    $ScimSchemaAttribute = $ScimSchemaAttribute.subAttributes | Where-Object name -EQ $NewHierarchyPath[$i]
                }
                if (!$ScimSchemaAttribute) {
                    Write-Error ('Attribute [{0}] does not exist in SCIM Schema Namespace [{1}].' -f ($NewHierarchyPath -join '.'), $ScimSchemaNamespace)
                    $result = $false
                }
                else {
                    if ($ScimSchemaAttribute.multiValued -and $_PropertyMapping.Value -isnot [array]) {
                        Write-Error ('Attribute [{0}] is multivalued in SCIM Schema Namespace [{1}] and must contain an array.' -f ($NewHierarchyPath -join '.'), $ScimSchemaNamespace)
                        $result = $false
                    }
                    foreach ($_PropertyMappingValue in $_PropertyMapping.Value) {
                        if ($ScimSchemaAttribute.type -eq 'Complex' -and $_PropertyMappingValue -is [string]) {
                            Write-Error ('Attribute [{0}] of Type [{2}] in SCIM Schema Namespace [{1}] cannot have simple mapping.' -f ($NewHierarchyPath -join '.'), $ScimSchemaNamespace, $ScimSchemaAttribute.type)
                            $result = $false
                        }
                        elseif ($ScimSchemaAttribute.type -ne 'Complex' -and ($_PropertyMappingValue -is [hashtable] -or $_PropertyMappingValue -is [System.Collections.Specialized.OrderedDictionary])) {
                            Write-Error ('Attribute [{0}] of Type [{2}] in SCIM Schema Namespace [{1}] cannot have complex mapping.' -f ($NewHierarchyPath -join '.'), $ScimSchemaNamespace, $ScimSchemaAttribute.type)
                            $result = $false
                        }
                        elseif ($_PropertyMappingValue -is [hashtable] -or $_PropertyMappingValue -is [System.Collections.Specialized.OrderedDictionary]) {
                            $nestedResult = Test-ScimAttributeMapping $_PropertyMappingValue $ScimSchemaNamespace $NewHierarchyPath
                            $result = $result -and $nestedResult
                        }
                    }
                }
            }
        }
        else {
            Write-Error ('Attribute Mapping Key [{0}] is invalid.' -f $_PropertyMapping.Key)
            $result = $false
        }
    }

    return $result
}

function ConvertTo-ScimBulkPayload {
    [CmdletBinding()]
    param (
        # Resource Data
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [object[]] $InputObject,
        # Map all input properties to specified custom SCIM namespace
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Alias('Namespace')]
        [string] $ScimSchemaNamespace,
        # Map input properties to SCIM attributes
        [Parameter(Mandatory = $false)]
        [hashtable] $AttributeMapping,
        # Operations per bulk request
        [Parameter(Mandatory = $false)]
        [int] $OperationsPerRequest = 50,
        # PassThru Object
        [Parameter(Mandatory = $false)]
        [switch] $PassThru
    )

    begin {
        $ScimBulkObject = [PSCustomObject][ordered]@{
            "schemas"      = @("urn:ietf:params:scim:api:messages:2.0:BulkRequest")
            "Operations"   = New-Object System.Collections.Generic.List[pscustomobject]
            "failOnErrors" = $null
        }
        $paramConvertToScimPayload = @{}
        if ($AttributeMapping) { $paramConvertToScimPayload['AttributeMapping'] = $AttributeMapping }
        $ScimBulkObjectInstance = $ScimBulkObject.psobject.Copy()
    }

    process {
        foreach ($obj in $InputObject) {

            $ScimOperationObject = [PSCustomObject][ordered]@{
                "method" = "POST"
                "bulkId" = [string](New-Guid)
                "path"   = "/Users"
                "data"   = ConvertTo-ScimPayload $obj -ScimSchemaNamespace $ScimSchemaNamespace -PassThru @paramConvertToScimPayload
            }
            $ScimBulkObjectInstance.Operations.Add($ScimOperationObject)

            # Output object when max operations has been reached
            if ($OperationsPerRequest -gt 0 -and $ScimBulkObjectInstance.Operations.Count -ge $OperationsPerRequest) {
                if ($PassThru) { $ScimBulkObjectInstance }
                else { ConvertTo-Json $ScimBulkObjectInstance -Depth 10 }
                $ScimBulkObjectInstance = $ScimBulkObject.psobject.Copy()
                $ScimBulkObjectInstance.Operations = New-Object System.Collections.Generic.List[pscustomobject]
            }
        }
    }

    end {
        if ($ScimBulkObjectInstance.Operations.Count -gt 0) {
            ## Return Object with SCIM Data Structure
            if ($PassThru) { $ScimBulkObjectInstance }
            else { ConvertTo-Json $ScimBulkObjectInstance -Depth 10 }
        }
    }
}

function ConvertTo-ScimPayload {
    [CmdletBinding()]
    param (
        # Resource Data
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [object[]] $InputObject,
        # Map all input properties to specified custom SCIM namespace
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Alias('Namespace')]
        [string] $ScimSchemaNamespace,
        # Map input properties to SCIM attributes
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [hashtable] $AttributeMapping = @{
            "externalId" = "externalId"
            "userName"   = "userName"
            "active"     = "active"
        },
        # PassThru Object
        [Parameter(Mandatory = $false)]
        [switch] $PassThru
    )

    begin {
        function Resolve-ScimAttributeMapping {
            param (
                # Resource Data
                [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
                [object] $InputObject,
                # Map input properties to SCIM attributes
                [Parameter(Mandatory = $true)]
                [hashtable] $AttributeMapping,
                # Add to existing hashtable or dictionary
                [Parameter(Mandatory = $false)]
                [object] $TargetObject = @{}
            )

            foreach ($_AttributeMapping in $AttributeMapping.GetEnumerator()) {

                if ($_AttributeMapping.Key -is [string] -and $_AttributeMapping.Key.StartsWith('urn:')) {
                    if (!$TargetObject['schemas'].Contains($_AttributeMapping.Key)) { $TargetObject['schemas'] += $_AttributeMapping.Key }
                }

                if ($_AttributeMapping.Value -is [array]) {
                    ## Force array output
                    $TargetObject[$_AttributeMapping.Key] = @(Resolve-PropertyMappingValue $InputObject $_AttributeMapping.Value)
                }
                else {
                    $TargetObject[$_AttributeMapping.Key] = Resolve-PropertyMappingValue $InputObject $_AttributeMapping.Value
                }
            }

            return $TargetObject
        }

        function Resolve-PropertyMappingValue {
            param (
                # Resource Data
                [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
                [object] $InputObject,
                # Property mapping value to output
                [Parameter(Mandatory = $true)]
                [object] $PropertyMappingValue
            )

            foreach ($_PropertyMappingValue in $PropertyMappingValue) {
                if ($_PropertyMappingValue -is [scriptblock]) {
                    Invoke-Transformation $InputObject $_PropertyMappingValue
                }
                elseif ($_PropertyMappingValue -is [hashtable] -or $_PropertyMappingValue -is [System.Collections.Specialized.OrderedDictionary]) {
                    Resolve-ScimAttributeMapping $InputObject $_PropertyMappingValue
                }
                else {
                    $InputObject.($_PropertyMappingValue)
                }
            }
        }

        function Invoke-Transformation {
            param (
                # Resource Data
                [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
                [object] $InputObject,
                # Transformation Script Block
                [Parameter(Mandatory = $true)]
                [scriptblock] $ScriptBlock
            )
    
            process {
                ## Using Import-PowerShellDataFile to load a scriptblock wraps it in another scriptblock so handling that with loop
                $ScriptBlockResult = $ScriptBlock
                while ($ScriptBlockResult -is [scriptblock]) {
                    $ScriptBlockResult = ForEach-Object -InputObject $InputObject -Process $ScriptBlockResult
                }

                return $ScriptBlockResult
            }
        }
    }

    process {
        foreach ($obj in $InputObject) {
            ## Generate Core SCIM Data Structure
            $ScimObject = [ordered]@{
                schemas = [string[]]("urn:ietf:params:scim:schemas:core:2.0:User", "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User", "urn:ietf:params:scim:schemas:extension:zoho:2.0:User")
            }

            ## Add Attributes to SCIM Data Structure
            $ScimObject = Resolve-ScimAttributeMapping $obj -AttributeMapping $AttributeMapping -TargetObject $ScimObject
            if ($ScimSchemaNamespace) {
                $ScimObject[$ScimSchemaNamespace] = $obj
                $ScimObject['schemas'] += $ScimSchemaNamespace
            }

            ## Return Object with SCIM Data Structure
            #$ScimObject = [PSCustomObject]$ScimObject
            if ($PassThru) { $ScimObject }
            else { ConvertTo-Json $ScimObject -Depth 5 }
        }
    }
}

function Get-ZohoPeopleEmployees {
    [CmdletBinding()]
    param (
        [datetime] $ImportSince = (Get-Date).AddDays(-30)
    )
    # Request alll employees from Zoho People API
    Write-Output "Requesting all employees from Zoho People API..."
    $employees = Invoke-RestMethod -Uri "$ZohoPeopleApiUrl/people/api/forms/employee/getRecords?sIndex=1&limit=100&modifiedtime=$([System.DateTimeOffset]::new($ImportSince).ToUnixTimeMilliseconds())" -Method Get -Headers @{ 
        "Authorization" = "Zoho-oauthtoken $($refreshToken.access_token)"
    }
    if($employees.response.message -ne "Data fetched successfully") {
        Write-Output "Failed to fetch employee data from Zoho People API. $($employees.response.message)"
        throw "Failed to fetch employee data from Zoho People API. $($employees.response.message)"
    } else {
        Write-Output "Employee data successfully fetched from Zoho People API."
    }
     
    $FormattedEmployeeObjects = @()
    # Loop through each employee in the result array
    foreach ($employeeGroup in $employees.response.result) {
        Write-Verbose "Processing Group: '$employeeGroup'"
        foreach ($employeeKey in $employeeGroup.PSObject.Properties) {
            Write-Verbose "Processing Key: '$($employeeKey.Name)'"
            foreach ($employee in $employeeGroup."$($employeeKey.Name)") {
                # Generate a PSObject with all properties for the employee
                $employeeObject = [PSCustomObject]@{
                    ZohoPeopleId             = $employeeKey
                }
                foreach ($property in $employee[0].PSObject.Properties) {
                    $propertyName = $property.Name
                    if($propertyName -like "*childValues"){
                        foreach ($childProp in $property.Value.PSObject.Properties) {
                            $propertyValue = $childProp.Value
                            # Add each property to the PSObject
                            $employeeObject | Add-Member -MemberType NoteProperty -Name "$propertyName`_$($childProp.Name)" -Value $propertyValue
                        }
                    
                    } else  {
                        $propertyValue = $property.Value
                    
                        # Add each property to the PSObject
                        $employeeObject | Add-Member -MemberType NoteProperty -Name $propertyName -Value $propertyValue
                    }
                } 

                # Generate FullName property
                try{
                    $employeeObject | Add-Member -MemberType NoteProperty -Name FullName -Value "$($employee.FirstName) $($employee.LastName)"
                } catch {
                    $employeeObject | Add-Member -MemberType NoteProperty -Name FullName -Value $employee.EmailID
                }
                $FormattedEmployeeObjects += $employeeObject
            }
        }
    }  
    return $FormattedEmployeeObjects                 
}

#endregion Functions

#region Initialize
# Authenticate with Azure using managed identity
Write-Output "Authenticating with Azure using managed identity..."
Connect-AzAccount -Identity -AccountId $env:AZURE_CLIENT_ID
Write-Output "Successfully authenticated with Azure."

Write-Output "Authenticating with MgGraph using managed identity..."
Connect-MgGraph -Identity -ClientId $env:AZURE_CLIENT_ID -NoWelcome -ErrorAction Stop
Write-Output "Successfully authenticated with MgGraph."

# Retrieve secrets from Azure Key Vault
Write-Output "Retrieving secrets from Azure Key Vault..."
$ClientSecret = Get-AzKeyVaultSecret -VaultName $env:KEYVAULT_NAME -Name "ZohoPeopleClientSecret" -AsPlainText
Write-Output "Retrieved Client Secret from Azure Key Vault."

$ClientId = Get-AzKeyVaultSecret -VaultName $env:KEYVAULT_NAME -Name "ZohoPeopleClientId" -AsPlainText
Write-Output "Retrieved Client ID from Azure Key Vault."

$RefreshToken = Get-AzKeyVaultSecret -VaultName $env:KEYVAULT_NAME -Name "ZohoPeopleRefreshToken" -AsPlainText
Write-Output "Retrieved Refresh Token from Azure Key Vault."

$AccountUrl = Get-AzKeyVaultSecret -VaultName $env:KEYVAULT_NAME -Name "ZohoPeopleAccountUrl" -AsPlainText
Write-Output "Retrieved Account URL from Azure Key Vault."

$ZohoPeopleApiUrl = Get-AzKeyVaultSecret -VaultName $env:KEYVAULT_NAME -Name "ZohoPeopleApiUrl" -AsPlainText
Write-Output "Retrieved PeopleApi URL from Azure Key Vault."

$ProvisioningAppObjectId = Get-AzKeyVaultSecret -VaultName $env:KEYVAULT_NAME -Name "ProvisioningAppObjectId" -AsPlainText
Write-Output "Retrieved ProvisioningApp ObjectId from Azure Key Vault."

# Region Get Provisioning Job information
$SyncJob = Get-MgServicePrincipalSynchronizationJob -ServicePrincipalId $ProvisioningAppObjectId -ErrorAction Stop
Write-Output "Retrieved Provisioning Job Id $($SyncJob.Id)."

# Request a new access token using the refresh token
Write-Output "Requesting a new access token from Zoho using the refresh token..."
$refreshToken = Invoke-RestMethod -Uri "$AccountUrl/oauth/v2/token?client_id=$ClientId&client_secret=$ClientSecret&grant_type=refresh_token&refresh_token=$RefreshToken" -Method Post
if($refreshToken.access_token) {
    Write-Output "Access token successfully retrieved."
} else {
    Write-Output "Failed to retrieve the access token."
    throw "Failed to retrieve the access token."
}

#endregion Initialize

#region Main Script

# Request alll employees from Zoho People API
# Can be changed to any other source but needs to return an array of object with a one level of properties
Write-Output "Requesting all employees from Zoho People API..."
$FormattedEmployeeObjects = Get-ZohoPeopleEmployees -ImportSince (Get-Date).AddDays(-1)


# Convert the employee objects to SCIM format
Write-Output "Converting employee objects to SCIM format..."
$FormattedEmployeeObjectsScim = $FormattedEmployeeObjects | ConvertTo-ScimBulkPayload -ScimSchemaNamespace $ScimSchemaNamespace -AttributeMapping $AttributeMapping

# Send SCIM data to Microsoft Graph API
Write-Output "Sending SCIM data to Microsoft Graph API..."
Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/beta/servicePrincipals/$ProvisioningAppObjectId/synchronization/jobs/$($SyncJob.Id)/bulkUpload" -ContentType 'application/scim+json' -Body $FormattedEmployeeObjectsScim 

#endregion Main Script

# Log the end of the timer-triggered function execution
Write-Output "Sync finished: $(Get-Date)"
