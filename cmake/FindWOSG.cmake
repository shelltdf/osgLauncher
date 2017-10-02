
#�������

#	WOSG_USE_STATIC_LIBRARY	ʹ�þ�̬osg��

#	WOSG_INCLUDE_DIR		inlcudeĿ¼
#	WOSG_INCLUDE_BUILD_DIR	inlcudeĿ¼
#	WOSG_LIBRARY_DIR		libĿ¼��û�ã�

#	WOSG_LIBRARY_ALL			ȫ�����ܴ��ڵ�lib�ļ���
#	WOSG_LIBRARY_ALL_PLUGINS	ȫ�����ܴ��ڵ�lib�ļ���
#   WOSG_LIBRARY_ALL_DEPEND

#ȫ�ֱ���

SET(WOSG_USE_STATIC_LIBRARY  OFF  CACHE BOOL "")
set(WOSG_PLUGINS_DIR_NAME    "osgPlugins-3.4.0" )

IF(MSVC)
    set(WOSG_STATIC_LIBRARY_PREFIX      "osg130-" )
    set(WOSG_STATIC_OT_LIBRARY_PREFIX   "ot20-"  )
    set(WOSG_STATIC_LIBRARY_POSTFIX     ""  )
    set(WOSG_STATIC_PLUGINS_POSTFIX     ".lib"  )
ENDIF(MSVC)

IF(CYGWIN)
    SET(WOSG_STATIC_LIBRARY_PREFIX      "lib"  )
    SET(WOSG_STATIC_OT_LIBRARY_PREFIX   "lib"  )
    SET(WOSG_STATIC_LIBRARY_POSTFIX     ".a" )
    set(WOSG_STATIC_PLUGINS_POSTFIX     ""  )
ENDIF(CYGWIN)

IF(ANDROID OR NACL )
    SET(WOSG_STATIC_LIBRARY_PREFIX      "lib"  )
    SET(WOSG_STATIC_OT_LIBRARY_PREFIX   "lib"  )
    SET(WOSG_STATIC_LIBRARY_POSTFIX     ".a" )
    set(WOSG_STATIC_PLUGINS_POSTFIX     ""  )
ENDIF(ANDROID OR NACL)


SET(WOSG_LIBRARY_ALL  )
SET(WOSG_LIBRARY_ALL_PLUGINS )
SET(WOSG_LIBRARY_ALL_DEPEND )


SET(MODULE_NAME_LIST
	osg osgDB osgUtil osgViewer osgGA 
    osgText 
    osgAnimation
	osgFX 
    osgManipulator 
    osgParticle 
	osgShadow osgSim osgTerrain 
	osgVolume osgWidget
	osgPresentation 
	#osgQt 
)

SET(PLUGINS_NAME_LIST
	3dc 3ds ac bmp bsp bvh cfg dds dot dw dxf 
	glsl hdr ive logo 
    # lwo 
    lws md2 mdl normals obj
	openflight osga p3d pic 
    # ply 
    pnm pov revisions rgb rot
	scale shp stl tga tgz trans txf 
    # txp
    vtf x 
	
	curl freetype 
    png 
    jpeg 
    tiff 
    # fbx
    zip
    nvtt
	# dae
    # gif
    gz
    # qfont
    # geo
    
    exr
    gif
    gles
    gz
    ktx
    lua
    lwo
    ogr
    osc
    openflight
    ply
    pov
    pvr
    tf
    trk
    txp
    
    
	osg
	deprecated_osg
	deprecated_osganimation
	deprecated_osgfx
	deprecated_osgparticle
	deprecated_osgshadow
	deprecated_osgsim
    deprecated_osgterrain
    deprecated_osgtext
    deprecated_osgviewer
    deprecated_osgvolume
    deprecated_osgwidget
	serializers_osg
	serializers_osganimation
	serializers_osgfx
    serializers_osgmanipulator
    serializers_osgparticle
    serializers_osgshadow
    serializers_osgsim
    serializers_osgterrain
    serializers_osgtext
    serializers_osgvolume
)

SET(DEPEND_NAME_LIST

)

	

#�������
FUNCTION(WOSG_FIND_PLUGINS VARNAME RESULT_NAME0 RESULT_NAME1)

	IF(WOSG_USE_STATIC_LIBRARY)
	
		#lib����
		SET(PLUGINS_LIB_NAME osgdb_${ARGV0})
		STRING(TOUPPER ${ARGV0} PLUGINS_LIB_NAME_UPPER )
		SET(PLUGINS_LIB WOSG_STATIC_PLUGINS_${PLUGINS_LIB_NAME_UPPER}_LIBRARY)

		#����release
		FIND_LIBRARY( ${PLUGINS_LIB}
						NAMES ${WOSG_PLUGINS_DIR_NAME}/${PLUGINS_LIB_NAME}${WOSG_STATIC_PLUGINS_POSTFIX}
						PATHS 
						"C:/Program Files/OpenSceneGraph/lib"
						"C:/Program Files (x86)/OpenSceneGraph/lib/"
						# $ENV{OSGDIR}/build/static/lib/osgPlugins-2.9.9
                        ${WOSG_INCLUDE_BUILD_DIR}/../lib/
						/usr/local/lib/
						) 
                        
        # message (waring " " ${WOSG_PLUGINS_DIR_NAME}/${PLUGINS_LIB_NAME}${WOSG_STATIC_PLUGINS_POSTFIX})
		#׷��
		set (${RESULT_NAME0} ${${PLUGINS_LIB}} PARENT_SCOPE)

        
		#�޸Ŀ�����
		SET(PLUGINS_LIB_NAME osgdb_${ARGV0}d)
		SET(PLUGINS_LIB WOSG_STATIC_PLUGINS_${PLUGINS_LIB_NAME_UPPER}_LIBRARY_DEBUG)

		#����debug
		FIND_LIBRARY( ${PLUGINS_LIB}
						NAMES ${WOSG_PLUGINS_DIR_NAME}/${PLUGINS_LIB_NAME}${WOSG_STATIC_PLUGINS_POSTFIX}
						PATHS 
						"C:/Program Files/OpenSceneGraph/lib"
						"C:/Program Files (x86)/OpenSceneGraph/lib/"
						# $ENV{OSGDIR}/build/static/lib/osgPlugins-2.9.9
						/usr/local/lib/
                        ${WOSG_INCLUDE_BUILD_DIR}/../lib/
						) 
		#׷��
		set (${RESULT_NAME1} ${${PLUGINS_LIB}} PARENT_SCOPE)
	
	ELSE(WOSG_USE_STATIC_LIBRARY)
	ENDIF(WOSG_USE_STATIC_LIBRARY)

ENDFUNCTION(WOSG_FIND_PLUGINS)



#����OpenThreads��DLL�;�̬
MACRO(WOSG_SETUP_OPENTHREADS_LIBRARIES)
	IF(WOSG_USE_STATIC_LIBRARY)
    
        #����debug
		FIND_LIBRARY( WOSG_STATIC_OPENTHREADS_LIBRARY_DEBUG
						NAMES ${WOSG_STATIC_OT_LIBRARY_PREFIX}OpenThreadsd${WOSG_STATIC_LIBRARY_POSTFIX}
						PATHS 
						"C:/Program Files/OpenSceneGraph/lib"
						"C:/Program Files (x86)/OpenSceneGraph/lib"
						# $ENV{OSGDIR}/build/static/bin
						/usr/local/lib/
                        ${WOSG_INCLUDE_BUILD_DIR}/../lib/
						) 
		#׷��
        # if( WOSG_STATIC_OPENTHREADS_LIBRARY_DEBUG )
            # list(APPEND WOSG_LIBRARY_ALL debug ${WOSG_STATIC_OPENTHREADS_LIBRARY_DEBUG} )
        # endif()
        
		#����release
        message("name=")
        message(${WOSG_INCLUDE_BUILD_DIR}/../lib/)
        message(${WOSG_STATIC_OT_LIBRARY_PREFIX}OpenThreads${WOSG_STATIC_LIBRARY_POSTFIX})
		FIND_LIBRARY( WOSG_STATIC_OPENTHREADS_LIBRARY
						NAMES ${WOSG_STATIC_OT_LIBRARY_PREFIX}OpenThreads${WOSG_STATIC_LIBRARY_POSTFIX}
						PATHS
                        ${WOSG_INCLUDE_BUILD_DIR}/../lib
						"C:/Program Files/OpenSceneGraph/lib"
						"C:/Program Files (x86)/OpenSceneGraph/lib"
						# $ENV{OSGDIR}/build/static/bin
						/usr/local/lib/
						) 
		#׷��
        # if( WOSG_STATIC_OPENTHREADS_LIBRARY_DEBUG )
             # list(APPEND WOSG_LIBRARY_ALL optimized )
             # message(${WOSG_STATIC_OPENTHREADS_LIBRARY_DEBUG})
        # endif()
		# list(APPEND WOSG_LIBRARY_ALL ${WOSG_STATIC_OPENTHREADS_LIBRARY} )
        # message(${WOSG_LIBRARY_ALL})

        
        if(WOSG_STATIC_OPENTHREADS_LIBRARY AND WOSG_STATIC_OPENTHREADS_LIBRARY_DEBUG)
            list(APPEND WOSG_LIBRARY_ALL optimized ${WOSG_STATIC_OPENTHREADS_LIBRARY} debug ${WOSG_STATIC_OPENTHREADS_LIBRARY_DEBUG}  )
        elseif(WOSG_STATIC_OPENTHREADS_LIBRARY)
            list(APPEND WOSG_LIBRARY_ALL ${WOSG_STATIC_OPENTHREADS_LIBRARY} )
        elseif(WOSG_STATIC_OPENTHREADS_LIBRARY_DEBUG)
            list(APPEND WOSG_LIBRARY_ALL ${WOSG_STATIC_OPENTHREADS_LIBRARY_DEBUG} )
        endif()
        
	
	ELSE(WOSG_USE_STATIC_LIBRARY)
		#����release
		FIND_LIBRARY( WOSG_DYNAMIC_OPENTHREADS_LIBRARY
						NAMES OpenThreads
						PATHS 
						"C:/Program Files/OpenSceneGraph/lib"
						"C:/Program Files (x86)/OpenSceneGraph/lib"
						# $ENV{OSGDIR}/build/dynamic/lib
						/usr/local/lib/
                        ${WOSG_INCLUDE_BUILD_DIR}/../lib/
						) 
		#׷��
		# list(APPEND WOSG_LIBRARY_ALL optimized ${WOSG_DYNAMIC_OPENTHREADS_LIBRARY} )
		#����debug
		FIND_LIBRARY( WOSG_DYNAMIC_OPENTHREADS_LIBRARY_DEBUG
						NAMES OpenThreadsd
						PATHS 
						"C:/Program Files/OpenSceneGraph/lib"
						"C:/Program Files (x86)/OpenSceneGraph/lib"
						# $ENV{OSGDIR}/build/dynamic/lib
						/usr/local/lib/
                        ${WOSG_INCLUDE_BUILD_DIR}/../lib/
						) 
		#׷��
		# list(APPEND WOSG_LIBRARY_ALL debug ${WOSG_DYNAMIC_OPENTHREADS_LIBRARY_DEBUG} )
        
        if(WOSG_DYNAMIC_OPENTHREADS_LIBRARY AND WOSG_DYNAMIC_OPENTHREADS_LIBRARY_DEBUG)
            list(APPEND WOSG_LIBRARY_ALL optimized ${WOSG_DYNAMIC_OPENTHREADS_LIBRARY} debug ${WOSG_DYNAMIC_OPENTHREADS_LIBRARY_DEBUG}  )
        elseif(WOSG_DYNAMIC_OPENTHREADS_LIBRARY)
            list(APPEND WOSG_LIBRARY_ALL ${WOSG_DYNAMIC_OPENTHREADS_LIBRARY} )
        elseif(WOSG_DYNAMIC_OPENTHREADS_LIBRARY_DEBUG)
            list(APPEND WOSG_LIBRARY_ALL ${WOSG_DYNAMIC_OPENTHREADS_LIBRARY_DEBUG} )
        endif()
        
	ENDIF(WOSG_USE_STATIC_LIBRARY)

ENDMACRO(WOSG_SETUP_OPENTHREADS_LIBRARIES)


#������DLL
MACRO(WOSG_SETUP_OSG_LIBRARIES)

	IF(WOSG_USE_STATIC_LIBRARY)
	
        STRING(TOUPPER ${ARGV0} dll_imp_lib_up )
    
    
        #lib����
		SET(dll_imp_lib ${WOSG_STATIC_LIBRARY_PREFIX}${ARGV0}d)

		#���������
		SET(dll_imp_lib_v2 WOSG_STATIC_${dll_imp_lib_up}_LIBRARY_DEBUG)

		#����debug
		FIND_LIBRARY( ${dll_imp_lib_v2}
						NAMES ${dll_imp_lib}${WOSG_STATIC_LIBRARY_POSTFIX}
						PATHS 
						"C:/Program Files/OpenSceneGraph/lib"
						"C:/Program Files (x86)/OpenSceneGraph/lib"
						# $ENV{OSGDIR}/build/static/bin
						/usr/local/bin/
                        ${WOSG_INCLUDE_BUILD_DIR}/../lib/
						) 
		#׷��
        # if( ${dll_imp_lib_v} )
            # list(APPEND WOSG_LIBRARY_ALL debug ${${dll_imp_lib_v}} )
        # endif()
        
        
   
		#lib����
		SET(dll_imp_lib ${WOSG_STATIC_LIBRARY_PREFIX}${ARGV0})

		#���������
		SET(dll_imp_lib_v WOSG_STATIC_${dll_imp_lib_up}_LIBRARY)

		#����release
		FIND_LIBRARY( ${dll_imp_lib_v}
						NAMES ${dll_imp_lib}${WOSG_STATIC_LIBRARY_POSTFIX}
						PATHS 
						"C:/Program Files/OpenSceneGraph/lib"
						"C:/Program Files (x86)/OpenSceneGraph/lib"
						# $ENV{OSGDIR}/build/static/bin
						/usr/local/lib/
                        ${WOSG_INCLUDE_BUILD_DIR}/../lib/
						) 

		#׷��
        # if( ${dll_imp_lib_v} )
            # list(APPEND WOSG_LIBRARY_ALL optimized )
        # endif()
        # list(APPEND WOSG_LIBRARY_ALL " " )
        # list(APPEND WOSG_LIBRARY_ALL ${${dll_imp_lib_v2}} )
        
        
        if(${dll_imp_lib_v} AND ${dll_imp_lib_v2})
            list(APPEND WOSG_LIBRARY_ALL optimized ${${dll_imp_lib_v}} debug ${${dll_imp_lib_v2}}  )
        elseif(${dll_imp_lib_v})
            list(APPEND WOSG_LIBRARY_ALL ${${dll_imp_lib_v}} )
        elseif(${dll_imp_lib_v2})
            list(APPEND WOSG_LIBRARY_ALL ${${dll_imp_lib_v2}} )
        endif()
        

	ELSE(WOSG_USE_STATIC_LIBRARY)
	
		#lib����
		SET(dll_imp_lib ${ARGV0})

		#���������
		STRING(TOUPPER ${ARGV0} dll_imp_lib_up )
		SET(dll_imp_lib_v WOSG_DYNAMIC_${dll_imp_lib_up}_LIBRARY)

		
		#����release
		FIND_LIBRARY( ${dll_imp_lib_v}
						NAMES ${dll_imp_lib} 
						PATHS 
						"C:/Program Files/OpenSceneGraph/lib"
						"C:/Program Files (x86)/OpenSceneGraph/lib"
						# $ENV{OSGDIR}/build/dynamic/lib
						/usr/local/lib/
                        ${WOSG_INCLUDE_BUILD_DIR}/../lib/
						) 
		#׷��
		# list(APPEND WOSG_LIBRARY_ALL optimized ${${dll_imp_lib_v}} )
		
		
		#�޸Ŀ�����
		SET(dll_imp_lib ${ARGV0}d)

		#�޸Ŀ��������
		SET(dll_imp_lib_v2 WOSG_DYNAMIC_${dll_imp_lib_up}_LIBRARY_DEBUG)

		#����debug
		FIND_LIBRARY( ${dll_imp_lib_v2}
						NAMES ${dll_imp_lib}
						PATHS 
						"C:/Program Files/OpenSceneGraph/lib"
						"C:/Program Files (x86)/OpenSceneGraph/lib"
						# $ENV{OSGDIR}/build/dynamic/lib
						/usr/local/lib/
                        ${WOSG_INCLUDE_BUILD_DIR}/../lib/
						) 

		#׷��
		# list(APPEND WOSG_LIBRARY_ALL debug ${${dll_imp_lib_v2}})
        
        
        if(${dll_imp_lib_v} AND ${dll_imp_lib_v2})
            list(APPEND WOSG_LIBRARY_ALL optimized ${${dll_imp_lib_v}} debug ${${dll_imp_lib_v2}}  )
        elseif(${dll_imp_lib_v})
            list(APPEND WOSG_LIBRARY_ALL ${${dll_imp_lib_v}} )
        elseif(${dll_imp_lib_v2})
            list(APPEND WOSG_LIBRARY_ALL ${${dll_imp_lib_v2}} )
        endif()
        
        
	ENDIF(WOSG_USE_STATIC_LIBRARY)
    
ENDMACRO(WOSG_SETUP_OSG_LIBRARIES)






#����OSG��includeĿ¼
FIND_PATH( WOSG_INCLUDE_DIR osg/Object
			"C:/Program Files/OpenSceneGraph/include"
			"C:/Program Files (x86)/OpenSceneGraph/include"
			# $ENV{OSGDIR}/Include
			/usr/local/Include/
            ../../perbuild/include
            ${WOSG_DIR}/include
            ${OSG_DIR}/include
			) 
            
#����OSG��includeĿ¼
FIND_PATH( WOSG_INCLUDE_DYNAMIC_BUILD_DIR osg/Config
			${WOSG_INCLUDE_DIR}/
			"C:/Program Files/OpenSceneGraph/include"
			"C:/Program Files (x86)/OpenSceneGraph/include"
			# $ENV{OSGDIR}/Include
			/usr/local/Include/
            ../../perbuild/include
            ${WOSG_DIR}/include
			) 

FIND_PATH( WOSG_INCLUDE_STATIC_BUILD_DIR osg/Config
            ${WOSG_INCLUDE_DIR}/
            "C:/Program Files/OpenSceneGraph/include"
            "C:/Program Files (x86)/OpenSceneGraph/include"
            # $ENV{OSGDIR}/Include
            /usr/local/Include/
            ../../perbuild/include
            ${WOSG_DIR}/include
            ) 
		
set( WOSG_LIBRARY_DIR ${WOSG_INCLUDE_DIR}/../lib )
            
set ( WOSG_INCLUDE_BUILD_DIR )            
IF(WOSG_USE_STATIC_LIBRARY)
    set ( WOSG_INCLUDE_BUILD_DIR ${WOSG_INCLUDE_STATIC_BUILD_DIR})
ELSE(WOSG_USE_STATIC_LIBRARY)
    set ( WOSG_INCLUDE_BUILD_DIR ${WOSG_INCLUDE_DYNAMIC_BUILD_DIR})
ENDIF(WOSG_USE_STATIC_LIBRARY)           
	  
message(${WOSG_INCLUDE_BUILD_DIR})
      
#����OT
WOSG_SETUP_OPENTHREADS_LIBRARIES()


#��������ģ��� ��̬��̬�Զ�ʶ��
foreach(_osg_component ${MODULE_NAME_LIST})
   WOSG_SETUP_OSG_LIBRARIES(${_osg_component})
endforeach()
# MESSAGE(STATUS ${WOSG_LIBRARY_ALL})	
# MESSAGE(STATUS ${WOSG_LIBRARY_ALL})	


#�������о�̬����� ��̬��̬�Զ�ʶ��
IF(WOSG_USE_STATIC_LIBRARY)

	#SET(PLUGINS_NAME)
	foreach(PLUGINS_NAME ${PLUGINS_NAME_LIST})
		# list(APPEND _osg_modules_to_process ${_osg_component})

		#����ֵ
		SET(PLUGINS_LIB_RELEASE)
		SET(PLUGINS_LIB_DEBUG)

		WOSG_FIND_PLUGINS( ${PLUGINS_NAME} PLUGINS_LIB_RELEASE PLUGINS_LIB_DEBUG )
		
		IF( WOSG_USE_STATIC_LIBRARY)
			# MESSAGE(WARING ${PLUGINS_LIB_RELEASE})
			# MESSAGE(WARING ${PLUGINS_LIB_DEBUG})
            
			# list(APPEND WOSG_LIBRARY_ALL_PLUGINS   optimized ${PLUGINS_LIB_RELEASE})
			# list(APPEND WOSG_LIBRARY_ALL_PLUGINS   debug ${PLUGINS_LIB_DEBUG})
            
            
            if(PLUGINS_LIB_RELEASE AND PLUGINS_LIB_DEBUG)
                list(APPEND WOSG_LIBRARY_ALL_PLUGINS optimized ${PLUGINS_LIB_RELEASE} debug ${PLUGINS_LIB_DEBUG})
            elseif(PLUGINS_LIB_RELEASE)
                list(APPEND WOSG_LIBRARY_ALL_PLUGINS ${PLUGINS_LIB_RELEASE})
            elseif(PLUGINS_LIB_DEBUG)
                list(APPEND WOSG_LIBRARY_ALL_PLUGINS ${PLUGINS_LIB_DEBUG})
            endif()
        
            
		ENDIF(WOSG_USE_STATIC_LIBRARY)
        
	endforeach()
	
	
	#�������
	MESSAGE(STATUS ${WOSG_LIBRARY_ALL_PLUGINS})	
	# MESSAGE(STATUS ${WOSG_LIBRARY_ALL_PLUGINS})	

	# MESSAGE(STATUS ${FIND_PLUGINS(osg)})	
	# MESSAGE(STATUS FIND_PLUGINS( osg ${PLUGINS_LIST}))	

	
	IF(MSVC)
        #������������
        # SET(WOSG_LIBRARY_ALL_DEPEND)
        SET(WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR ${PROJECT_SOURCE_DIR}/../../perbuild/lib  CACHE STRING "" )
        SET(WOSG_LIBRARY_POSTFIX .lib )
        
        #׷��
        list(APPEND WOSG_LIBRARY_ALL_DEPEND optimized  ${WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR}/freetype${WOSG_LIBRARY_POSTFIX} )
        list(APPEND WOSG_LIBRARY_ALL_DEPEND debug      ${WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR}/freetyped${WOSG_LIBRARY_POSTFIX}  )
        
        list(APPEND WOSG_LIBRARY_ALL_DEPEND optimized  ${WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR}/jpeg${WOSG_LIBRARY_POSTFIX} )
        list(APPEND WOSG_LIBRARY_ALL_DEPEND debug      ${WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR}/jpegd${WOSG_LIBRARY_POSTFIX}  )
        
        list(APPEND WOSG_LIBRARY_ALL_DEPEND optimized  ${WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR}/libpng16${WOSG_LIBRARY_POSTFIX} )
        list(APPEND WOSG_LIBRARY_ALL_DEPEND debug      ${WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR}/libpng16d${WOSG_LIBRARY_POSTFIX}  )
        
        # list(APPEND WOSG_LIBRARY_ALL_DEPEND optimized  ${WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR}/zlib${WOSG_LIBRARY_POSTFIX} )
        # list(APPEND WOSG_LIBRARY_ALL_DEPEND debug      ${WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR}/zlibd${WOSG_LIBRARY_POSTFIX}  )
        
        list(APPEND WOSG_LIBRARY_ALL_DEPEND optimized  ${WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR}/libtiff_i${WOSG_LIBRARY_POSTFIX} )
        list(APPEND WOSG_LIBRARY_ALL_DEPEND debug      ${WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR}/libtiffd_i${WOSG_LIBRARY_POSTFIX}  )
        
        list(APPEND WOSG_LIBRARY_ALL_DEPEND optimized  ${WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR}/libcurl${WOSG_LIBRARY_POSTFIX} )
        list(APPEND WOSG_LIBRARY_ALL_DEPEND debug      ${WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR}/libcurld${WOSG_LIBRARY_POSTFIX}  )
        
        # list(APPEND WOSG_LIBRARY_ALL_DEPEND optimized  ${WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR}/static/nvtt${WOSG_LIBRARY_POSTFIX} )
        # list(APPEND WOSG_LIBRARY_ALL_DEPEND debug      ${WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR}/static/nvttd${WOSG_LIBRARY_POSTFIX}  )
        # list(APPEND WOSG_LIBRARY_ALL_DEPEND optimized  ${WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR}/static/nvcore${WOSG_LIBRARY_POSTFIX} )
        # list(APPEND WOSG_LIBRARY_ALL_DEPEND debug      ${WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR}/static/nvcored${WOSG_LIBRARY_POSTFIX}  )
        # list(APPEND WOSG_LIBRARY_ALL_DEPEND optimized  ${WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR}/static/nvimage${WOSG_LIBRARY_POSTFIX} )
        # list(APPEND WOSG_LIBRARY_ALL_DEPEND debug      ${WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR}/static/nvimaged${WOSG_LIBRARY_POSTFIX}  )
        # list(APPEND WOSG_LIBRARY_ALL_DEPEND optimized  ${WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR}/static/nvmath${WOSG_LIBRARY_POSTFIX} )
        # list(APPEND WOSG_LIBRARY_ALL_DEPEND debug      ${WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR}/static/nvmathd${WOSG_LIBRARY_POSTFIX}  )
        # list(APPEND WOSG_LIBRARY_ALL_DEPEND optimized  ${WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR}/static/squish${WOSG_LIBRARY_POSTFIX} )
        # list(APPEND WOSG_LIBRARY_ALL_DEPEND debug      ${WOSG_LIBRARY_ALL_3RDPARTY_LIBDIR}/static/squishd${WOSG_LIBRARY_POSTFIX}  )
        
	ENDIF(MSVC)
    
ENDIF(WOSG_USE_STATIC_LIBRARY)




	   