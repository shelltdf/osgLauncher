
#include <osg/PositionAttitudeTransform>
#include <osg/ShapeDrawable>
#include <osg/Shape>
#include <osg/MatrixTransform>
#include <osgDB/ReadFile>
#include <osgDB/WriteFile>
#include <osgViewer/Viewer>
#include <osgViewer/ViewerEventHandlers>
#include <osgGA/StateSetManipulator>
#include <osgGA/TrackballManipulator>

#include "../common/launcher.h"
#include "../common/use_osg_static_library.h"



osg::Program* loadProgram(const std::string& vs_string, const std::string& fs_string)
{
    osg::Program* p = new osg::Program();

    osg::Shader* vs = new osg::Shader(osg::Shader::VERTEX, vs_string);
    osg::Shader* fs = new osg::Shader(osg::Shader::FRAGMENT, fs_string);

    p->addShader(vs);
    p->addShader(fs);

    return p;
}


void GLES_SS(osg::StateSet* ss)
{
	//#ifdef OSG_GLES2_AVAILABLE
#if 1

	//GLES2
    //root->getOrCreateStateSet()->setAttributeAndModes(loadProgram(
    ss->setAttributeAndModes(loadProgram(
		//vs
		"attribute vec4 osg_MultiTexCoord0;                                     \n"
        "varying vec4 color;                                                    \n"
        "varying vec4 uv;                                                       \n"
		"const vec3 lightPos      =vec3(0.0, 0.0, 10.0);                        \n"
		"const vec4 cessnaColor   =vec4(0.8, 0.8, 0.8, 1.0);                    \n"
		"const vec4 lightAmbient  =vec4(0.1, 0.1, 0.1, 1.0);                    \n"
		"const vec4 lightDiffuse  =vec4(1.0, 1.0, 1.0, 1.0);                    \n"
		"const vec4 lightSpecular =vec4(0.8, 0.8, 0.8, 1.0);                    \n"
		"void DirectionalLight(in vec3 normal,                                  \n"
		"                      in vec3 ecPos,                                   \n"
		"                      inout vec4 ambient,                              \n"
		"                      inout vec4 diffuse,                              \n"
		"                      inout vec4 specular)                             \n"
		"{                                                                      \n"
		"     float nDotVP;                                                     \n"
		"     vec3 L = normalize(gl_ModelViewMatrix*vec4(lightPos, 0.0)).xyz;   \n"
		"     nDotVP = max(0.0, dot(normal, L));                                \n"
		"                                                                       \n"
		"     if (nDotVP > 0.0) {                                               \n"
		"       vec3 E = normalize(-ecPos);                                     \n"
		"       vec3 R = normalize(reflect( L, normal ));                       \n"
		"       specular = pow(max(dot(R, E), 0.0), 16.0) * lightSpecular;      \n"
		"     }                                                                 \n"
		"     ambient  = lightAmbient;                                          \n"
		"     diffuse  = lightDiffuse * nDotVP;                                 \n"
		"}                                                                      \n"
		"void main() {                                                          \n"
		"    vec4 ambiCol = vec4(0.0);                                          \n"
		"    vec4 diffCol = vec4(0.0);                                          \n"
		"    vec4 specCol = vec4(0.0);                                          \n"
		"    gl_Position   = gl_ModelViewProjectionMatrix * gl_Vertex;          \n"
		"    vec3 normal   = normalize(gl_NormalMatrix * gl_Normal);            \n"
		"    vec4 ecPos    = gl_ModelViewMatrix * gl_Vertex;                    \n"
		"    DirectionalLight(normal, ecPos.xyz, ambiCol, diffCol, specCol);    \n"
		"    color = cessnaColor * (ambiCol + diffCol + specCol);               \n"
		"    uv = osg_MultiTexCoord0;                                           \n"
		"}                                                                      \n"
        "\n"
        ,
		
		//fs
        "precision mediump float;                  \n"
		"uniform sampler2D tex;                    \n"
		"varying mediump vec4 uv;                  \n"
		"varying mediump vec4 color;               \n"
		"void main() {                             \n"
		//"  gl_FragColor = color;                   \n"
		"  gl_FragColor = color * texture2D( tex, uv.st ); \n"
		"}                                         \n"
        "\n"
    )
    //, osg::StateAttribute::ON | osg::StateAttribute::PROTECTED);
    //, osg::StateAttribute::ON | osg::StateAttribute::OVERRIDE);
    , osg::StateAttribute::ON );
	
#endif
}



#if 1
#include <osgText/String>
#include <osgText/Text>
class myTextNode
{
public:
    myTextNode(const osg::Vec3& pos)
    {
        mPAT = new osg::PositionAttitudeTransform();
        mGeode = new osg::Geode();
        mText = new osgText::Text();
        mGeode->addDrawable(mText);
        mPAT->addChild(mGeode);
        mPAT->setPosition(pos);


        mText->setCharacterSize(24);
        mText->setCharacterSizeMode(osgText::Text::SCREEN_COORDS);
    }

    osg::PositionAttitudeTransform* mPAT;
    osg::Geode* mGeode;
    osgText::Text* mText;
};
#endif


class FileNotifyHandler 
    : public osg::NotifyHandler
{
public:
    FileNotifyHandler()
    {
        errfile.open("osgnoify_err.txt");
        outfile.open("osgnoify_out.txt");
    }

    void notify(osg::NotifySeverity severity, const char *message)
    {
        if (severity <= osg::WARN)
        {
            //fputs(message, stderr);
            errfile << message;
        }
        else
        {
            //fputs(message, stdout);
            outfile << message;
        }
    }

    std::ofstream errfile;
    std::ofstream outfile;

};

float a = 1.0;
float r = 1.0;

void onCreate(
    osgViewer::Viewer* viewer, osg::Group* root
    , float x, float y, float w, float h
    )
{
	//g_viewer = viewer;
	//g_root = root;


    osg::NotifyHandler* nh = osg::getNotifyHandler();
    if(nh)
    {
        FileNotifyHandler* fnh = dynamic_cast<FileNotifyHandler*>(nh);
        if (!fnh)
        {
            osg::setNotifyHandler(new FileNotifyHandler());
        }
    }
    else
    {
        osg::setNotifyHandler(new FileNotifyHandler());
    }

	
    viewer->getCamera()->setClearColor(osg::Vec4(1, 0, 0, 1));
    //viewer->setThreadingModel(osgViewer::Viewer::SingleThreaded);

#if 0

    //BOX
    osg::ShapeDrawable* sd = new osg::ShapeDrawable(
        new osg::Box(osg::Vec3(0, 0, 0), 1.0));
    osg::Geode* geode = new osg::Geode();
    geode->addDrawable(sd);
    //root->addChild(geode);

    osg::MatrixTransform* mt = new osg::MatrixTransform();
    mt->addChild(geode);
    root->addChild(mt);


    GLES_SS(root->getOrCreateStateSet());

    //sgv->apply(*mapNode);
	//root->accept(*sgv);

#endif


#if 0
    //load font
    //osgText::Font* font = osgText::readFontFile("../data/_osgxi/_font/msyh.ttf");


    //HUD
    osg::Camera* hud = new osg::Camera();
    hud->setReferenceFrame(osg::Camera::ABSOLUTE_RF);
    hud->setProjectionMatrixAsOrtho(0, 640, 0, 480, -1, 1);
    hud->setClearMask(GL_DEPTH_BUFFER_BIT);
    hud->getOrCreateStateSet()->setMode(GL_LIGHTING, false);
    root->addChild(hud);

    //////////////////////////////////////////////////////////////////////////
    //中文显示的四种接口 （三种可行）
    //////////////////////////////////////////////////////////////////////////

    myTextNode* MTN_01 = new myTextNode(osg::Vec3(0, 24 * 0, 0));
    //MTN_01->mText->setFont(font);
    MTN_01->mText->setText(L"01_ABC中文显示123 wchar_t");
    hud->addChild(MTN_01->mPAT);

    myTextNode* MTN_02 = new myTextNode(osg::Vec3(0, 24 * 1, 0));
    //MTN_02->mText->setFont(font);
    MTN_02->mText->setText(L"02_ABC中文显示123 std::string + ENCODING");
    hud->addChild(MTN_02->mPAT);

    myTextNode* MTN_03 = new myTextNode(osg::Vec3(0, 24 * 2, 0));
    //MTN_03->mText->setFont(font);
    MTN_03->mText->setText(std::string("03_ABC中文显示123 std::string"));//这个接口貌似无法实现中文正常显示
    hud->addChild(MTN_03->mPAT);

    myTextNode* MTN_04 = new myTextNode(osg::Vec3(0, 24 * 3, 0));
    osgText::String osgStr(L"04_ABC中文显示123");
    //MTN_04->mText->setFont(font);
    MTN_04->mText->setText(osgStr);
    hud->addChild(MTN_04->mPAT);

#endif


	//add earth
	//Map* map = new Map();
	
	// addImagery( map );
    // addElevation( map );
	
	//map node
	//MapNode* mapNode = new MapNode( map );
     //root->addChild( mapNode );
	
	//
	// EarthManipulator* manip = new EarthManipulator();
    // viewer->setCameraManipulator( manip );
	
	// zoom to a good startup position
    // manip->setViewpoint( Viewpoint(
        // "Home",
        // -71.0763, 42.34425, 0,   // longitude, latitude, altitude
         // 24.261, -21.6, 3450.0), // heading, pitch, range
         // 5.0 );                    // duration

    // This will mitigate near clip plane issues if you zoom in close to the ground:
    // LogarithmicDepthBuffer buf;
    // buf.install( viewer->getCamera() );
	

    //// add the state manipulator
    //viewer->addEventHandler( new osgGA::StateSetManipulator(viewer->getCamera()->getOrCreateStateSet()) );
    //// add the stats handler
    //viewer->addEventHandler(new osgViewer::StatsHandler);
	

#if 1
	osgGA::TrackballManipulator* tm = new osgGA::TrackballManipulator();
    viewer->setCameraManipulator(tm);


    // add the state manipulator
    viewer->addEventHandler(new osgGA::StateSetManipulator(viewer->getCamera()->getOrCreateStateSet()));

    // add the thread model handler
    viewer->addEventHandler(new osgViewer::ThreadingHandler);

    // add the window size toggle handler
    viewer->addEventHandler(new osgViewer::WindowSizeHandler);

    // add the stats handler
    osgViewer::StatsHandler* sh = new osgViewer::StatsHandler();
    sh->setKeyEventTogglesOnScreenStats('S');
    viewer->addEventHandler(sh);

    // add the help handler
    //viewer->addEventHandler(new osgViewer::HelpHandler(arguments.getApplicationUsage()));

    // add the record camera path handler
    viewer->addEventHandler(new osgViewer::RecordCameraPathHandler);

    // add the LOD Scale handler
    viewer->addEventHandler(new osgViewer::LODScaleHandler);

    // add the screen capture handler
    viewer->addEventHandler(new osgViewer::ScreenCaptureHandler);



	//前置更新
    viewer->frame();
    // osgViewer::GraphicsWindow* gw = dynamic_cast<osgViewer::GraphicsWindow*>( viewer->getCamera()->getGraphicsContext() );
    // if ( gw )
    {
        // Send window size event for initializing
        // int x, y, w, h; gw->getWindowRectangle( x, y, w, h );
        viewer->getEventQueue()->windowResize( x, y, w, h );
		viewer->getCamera()->setViewport(x, y, w, h);

        viewer->getCamera()->getGraphicsContext()->resized(x, y, w, h);

    }
#endif
	
}

void onFrame(osgViewer::Viewer* viewer, double dt)
{
     //r += dt * 90;
     //mt->setMatrix(
     //    osg::Matrix::rotate(osg::DegreesToRadians(r), osg::Vec3(0, 1, 0))
     //    //* osg::Matrix::translate(0, 0, -3)
     //    );
	

    //a += 0.01;
    r += 0.01;

}

void onDestory(osgViewer::Viewer* viewer, osg::Group* root)
{
}


void onMessage(osgViewer::Viewer* viewer,std::string str)
{
	//remove all
	viewer->getSceneData()->asGroup()->removeChildren(0,viewer->getSceneData()->asGroup()->getNumChildren());

#if 0
    osgEarth::Drivers::FileSystemCacheOptions cacheOptions;
    cacheOptions.rootPath() = "d:/aaaaa";

    MapOptions mapOptions;
    mapOptions.cache() = cacheOptions;


	//add earth
    osgEarth::Map* map = new osgEarth::Map(mapOptions);
	map->getProfile();

	addImagery( map );
	addElevation( map );
	addBuildings( map );
    addStreets( map );


	//map node
	osgEarth::MapNode* mapNode = new osgEarth::MapNode( map );
	//g_root->addChild( mapNode );
	viewer->getSceneData()->asGroup()->addChild( mapNode );


	//sky
	initSkyNode(viewer, mapNode);

	//shader
	//GLES_SS(mapNode->getOrCreateStateSet());

	//mapNode->accept(*sgv);
	//sgv->apply(*mapNode);


	//
	osgEarth::Util::EarthManipulator* manip = new osgEarth::Util::EarthManipulator();
	viewer->setCameraManipulator( manip );

	// zoom to a good startup position
	manip->setViewpoint( osgEarth::Viewpoint(
		"Home",
		-71.0763, 42.34425, 0,   // longitude, latitude, altitude
		24.261, -21.6, 3450.0), // heading, pitch, range
		5.0 );                    // duration

	// This will mitigate near clip plane issues if you zoom in close to the ground:
	// LogarithmicDepthBuffer buf;
	// buf.install( viewer->getCamera() );


	//// add the state manipulator
	//viewer->addEventHandler( new osgGA::StateSetManipulator(viewer->getCamera()->getOrCreateStateSet()) );
	//// add the stats handler
	//viewer->addEventHandler(new osgViewer::StatsHandler);
#else

#endif

}


void onSize(osgViewer::Viewer* viewer,int w, int h)
{
#if 0
	//g_root->accept(*sgv);

	//osgText::Font* font = osgText::readFontFile("data/msyh.ttf");

	//g_viewer->getCamera()->setViewport(0, 0, 100, 100);

	g_viewer->getEventQueue()->windowResize( 0, 0, w, h );
	g_viewer->getCamera()->setViewport(0, 0, w, h);
	//g_viewer->getCamera()->setProjectionMatrixAsPerspective(osg::DegreesToRadians(30.0f),float(w)/float(h),0.001,1000);
	g_viewer->getCamera()->setProjectionMatrixAsPerspective(30.0f,float(w)/float(h),0.001,1000);
#endif

	viewer->getEventQueue()->windowResize( 0, 0, w, h );
	viewer->getCamera()->setViewport(0, 0, w, h);
	//viewer->getCamera()->setProjectionMatrixAsPerspective(osg::DegreesToRadians(30.0f),float(w)/float(h),0.001,1000);
	viewer->getCamera()->setProjectionMatrixAsPerspective(30.0f,float(w)/float(h),0.001,1000);

    viewer->getCamera()->getGraphicsContext()->resized(0, 0, w, h);

}


void onMouse(osgViewer::Viewer* viewer,int type ,int moustbutton, int moustbuttonstate, int x, int y)
{

    viewer->getEventQueue()->getCurrentEventState()->setGraphicsContext(viewer->getCamera()->getGraphicsContext());

	if(type == 1) //click
	{
		osgGA::GUIEventAdapter::MouseButtonMask mm = osgGA::GUIEventAdapter::MouseButtonMask(0);
		if(moustbutton==1) mm = osgGA::GUIEventAdapter::LEFT_MOUSE_BUTTON;
		if(moustbutton==2) mm = osgGA::GUIEventAdapter::MIDDLE_MOUSE_BUTTON;
		if(moustbutton==3) mm = osgGA::GUIEventAdapter::RIGHT_MOUSE_BUTTON;

		if(moustbuttonstate)
		{
			viewer->getEventQueue()->mouseButtonPress(x,y,mm);
		}
		else
		{
			viewer->getEventQueue()->mouseButtonRelease(x,y,mm);
		}
	}

	if(type == 2) //move
	{
		viewer->getEventQueue()->mouseMotion(x,y);
	}

	if(type == 3)
	{
	}

	if(type == 4) //scroll
	{
		if(y > 0)
		{
			viewer->getEventQueue()->mouseScroll(osgGA::GUIEventAdapter::SCROLL_UP);
		}
		else
		{
			viewer->getEventQueue()->mouseScroll(osgGA::GUIEventAdapter::SCROLL_DOWN);
		}
	}

    if (type == 5) //double click
    {
        osgGA::GUIEventAdapter::MouseButtonMask mm = osgGA::GUIEventAdapter::MouseButtonMask(0);
        if (moustbutton == 1) mm = osgGA::GUIEventAdapter::LEFT_MOUSE_BUTTON;
        if (moustbutton == 2) mm = osgGA::GUIEventAdapter::MIDDLE_MOUSE_BUTTON;
        if (moustbutton == 3) mm = osgGA::GUIEventAdapter::RIGHT_MOUSE_BUTTON;


        viewer->getEventQueue()->mouseDoubleButtonPress(x, y, mm);
    }
}

void onKey(osgViewer::Viewer* viewer, int keycode, int keystate, int x, int y)
{
    // TCHAR szLog[512] = { 0 };
    // sprintf(szLog, ("onKey [%d, %d ,%c]\n"), keycode, keystate, char(keycode));
    // OutputDebugString(szLog);

    if (keystate > 0)
    {
        viewer->getEventQueue()->keyPress(keycode);
    }
    else
    {
        viewer->getEventQueue()->keyRelease(keycode);
    }

}