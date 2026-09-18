ifeq ($(WITH_GMS),true)
    # Special handling for Android TV
    ifeq ($(PRODUCT_IS_ATV),true)
        ifneq (,$(wildcard vendor/partner_gms-tv))
            ifneq ($(GMS_MAKEFILE),)
                # Specify the GMS makefile you want to use, for example:
                #   - gms.mk            - default Android TV GMS
                #   - gms_gtv.mk        - default Google TV GMS
                #   - gms_minimal.mk    - minimal Android TV GMS
                $(call inherit-product, vendor/partner_gms-tv/products/$(GMS_MAKEFILE))
            else
                $(call inherit-product-if-exists, vendor/partner_gms-tv/products/gms.mk)
            endif
            $(call inherit-product-if-exists, vendor/partner_gms-tv/products/mainline_modules.mk)
        else ifneq (,$(wildcard vendor/gapps_tv/arm64/arm64-vendor.mk))
            # MindTheGapps Android TV source uses its own vendor/gapps_tv
            # layout and exposes an architecture-specific product makefile.
            # Keep the standard partner_gms-tv path first so existing GMS
            # providers retain precedence when both trees are present.
            $(call inherit-product, vendor/gapps_tv/arm64/arm64-vendor.mk)
        endif
    # Special handling for Android Automotive
    else ifeq ($(PRODUCT_IS_AUTOMOTIVE),true)
        ifneq (,$(wildcard vendor/partner_gms-car))
            ifneq ($(GMS_MAKEFILE),)
                $(call inherit-product, vendor/partner_gms-car/products/$(GMS_MAKEFILE))
            else
                $(call inherit-product-if-exists, vendor/partner_gms-car/products/gms.mk)
            endif
        endif
   else
        ifneq (,$(wildcard vendor/partner_gms))
            # Specify the GMS makefile you want to use, for example:
            #   - fi.mk             - Project Fi
            #   - gms.mk            - default GMS
            #   - gms_go.mk         - low ram devices
            #   - gms_go_2gb.mk     - low ram devices (2GB)
            #   - gms_64bit_only.mk - devices supporting 64-bit only
            #   - gms_minimal.mk    - minimal GMS
            ifneq ($(GMS_MAKEFILE),)
                $(call inherit-product, vendor/partner_gms/products/$(GMS_MAKEFILE))
            else
                $(call inherit-product-if-exists, vendor/partner_gms/products/gms.mk)
            endif
        endif

        ifneq (,$(wildcard vendor/partner_modules))
            # Specify the mainline module makefile you want to use, for example:
            #   - mainline_modules.mk              - updatable apex
            #   - mainline_modules_flatten_apex.mk - flatten apex
            #   - mainline_modules_low_ram.mk      - low ram devices
            ifneq ($(MAINLINE_MODULES_MAKEFILE),)
                $(call inherit-product, vendor/partner_modules/build/$(MAINLINE_MODULES_MAKEFILE))
            endif
        endif
    endif
endif
