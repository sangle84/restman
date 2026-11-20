package server;

import java.io.File;
import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.core.StandardContext;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

public class ServerRunner {
    public static void main(String[] args) {
        try {
            int port = 8080;
            String webappDir = new File("src/main/webapp").getAbsolutePath();
            String baseDir = new File("target/tomcat").getAbsolutePath();

            Tomcat tomcat = new Tomcat();
            tomcat.setPort(port);
            tomcat.setBaseDir(baseDir);
            tomcat.getConnector();

            // Set parent classloader for Engine and Context so JspServlet (Jasper) can be loaded
            ClassLoader cl = ServerRunner.class.getClassLoader();
            tomcat.getEngine().setParentClassLoader(cl);

            StandardContext ctx = (StandardContext) tomcat.addWebapp("", webappDir);
            ctx.setParentClassLoader(cl);

            File additionWebInfClasses = new File("target/classes");
            if (additionWebInfClasses.exists()) {
                WebResourceRoot resources = new StandardRoot(ctx);
                resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes",
                        additionWebInfClasses.getAbsolutePath(), "/"));
                ctx.setResources(resources);
            }

            tomcat.start();
            System.out.println("=================================================");
            System.out.println("RestMan Server is running at http://localhost:" + port + "/");
            System.out.println("=================================================");
            tomcat.getServer().await();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
