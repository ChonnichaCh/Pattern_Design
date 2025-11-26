using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace BuilderPattern
{
    class Robot
    {
        private string peerIP;
        private int peerPort;
        private List<(string ip, int port)> allPeers = new List<(string ip, int port)>();

        public string name;
        public List<string> sensors = new List<string>();
        public string camera;
        public string mobility;
        public string coordination;
        public string processing;
        public string navigation;

        public void setPeer(string ip, int port)
        {
            peerIP = ip;
            peerPort = port;
            Console.WriteLine("robot name: " + name);
            Console.WriteLine("set peer: " + peerIP + ", " + peerPort);
        }

        public void connectToPeer(string ip, int port)
        {
            if (!(peerIP == ip && peerPort == port))
            {
                allPeers.Add((ip, port));
            }
        }

        public void detail()
        {
            Console.WriteLine("----- " + name + " -----");
            Console.WriteLine("sensors: " + string.Join(", ", sensors));
            Console.WriteLine("camera: " + camera);
            Console.WriteLine("mobility: " + mobility);
            Console.WriteLine("coordination: " + coordination);
            Console.WriteLine("processing: " + processing);
            Console.WriteLine("navigation: " + navigation);
        }
    }

    interface RobotBuilder
    {
        void setName();
        void setSensors();
        void setCamera();
        void setMobility();
        void setNavigation();
        void setCoordination();
        void setProcessing();
        Robot getRobot();
    }

    class RescueRobotBuilder : RobotBuilder
    {
        private Robot robot = new Robot();

        public void setName() => robot.name = "rescue robot";
        public void setSensors() => robot.sensors.AddRange(new[] { "gas sensor", "thermal sensor", "proximity sensor" });
        public void setCamera() => robot.camera = "infrared camera";
        public void setMobility() => robot.mobility = "wheeled";
        public void setNavigation() => robot.navigation = "GPS";
        public void setCoordination() => robot.coordination = "P2P mesh";
        public void setProcessing() => robot.processing = "ARM A72";
        public Robot getRobot() => robot;
    }

    class ExplorerRobotBuilder : RobotBuilder
    {
        private Robot robot = new Robot();

        public void setName() => robot.name = "explorer robot";
        public void setSensors() => robot.sensors.AddRange(new[] { "temperature sensor", "humidity sensor", "pressure sensor" });
        public void setCamera() => robot.camera = "4K camera";
        public void setMobility() => robot.mobility = "tracked";
        public void setNavigation() => robot.navigation = "LIDAR";
        public void setCoordination() => robot.coordination = "P2P mesh";
        public void setProcessing() => robot.processing = "ESP32";
        public Robot getRobot() => robot;
    }

    class RobotDirector
    {

        public Robot soloRobot(RobotBuilder builder)
        {
            builder.setName();
            builder.setSensors();
            builder.setCamera();
            builder.setMobility();
            builder.setNavigation();
            builder.setProcessing();
            return builder.getRobot();
        }

        public Robot groupRobot(RobotBuilder builder)
        {
            builder.setName();
            builder.setSensors();
            builder.setCamera();
            builder.setMobility();
            builder.setNavigation();
            builder.setCoordination();
            builder.setProcessing();
            return builder.getRobot();
        }
    }

    class Program
    {
        static void Main()
        {
            var director = new RobotDirector();
            var groupRobots = new List<Robot>();

            var rescueBuilder = new RescueRobotBuilder();
            for (int i = 0; i < 2; i++)
            {
                var rescueRobot = director.groupRobot(rescueBuilder);
                rescueRobot.setPeer("192.168.1." + (100 + i), 5000 + i);
                groupRobots.Add(rescueRobot);
            }
            var explorerBuilder = new ExplorerRobotBuilder();
            var explorerRobot = director.groupRobot(explorerBuilder);
            explorerRobot.setPeer("192.168.1.200", 6000);
            groupRobots.Add(explorerRobot);

            Console.WriteLine("\n\n\n=== Group Robots ===");
            foreach (var robot in groupRobots)
            {
                robot.detail();
                Console.WriteLine();
            }

            Console.WriteLine("\n");
            var soloRobot = director.soloRobot(explorerBuilder);
            soloRobot.setPeer("192.168.1.250", 7000);

            Console.WriteLine("\n\n\n=== Solo Robot ===");
            soloRobot.detail();
        }
    }
}
