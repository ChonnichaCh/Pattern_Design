import json
import csv
import random
import time
from datetime import datetime

class DataLogger:
    def log(self, data: dict):
        raise NotImplementedError("this method must be implement")

class JSONFile(DataLogger):
    def log(self, data):
        with open("log.json", "a", encoding="utf-8") as f:
            json.dump(data, f)
            f.write("\n")
        print(f"[JSON] Logged : {data}")
        
class CSVFile(DataLogger):
    def log(self, data):
        file_exists = False
        try:
            with open("log.csv", "r", encoding="utf-8"):
                file_exists = True
        except FileNotFoundError:
            pass
        with open("log.csv", "a", newline='', encoding="utf-8") as f:
            writer = csv.writer(f)
            if not file_exists:
                writer.writerow(["sensor_id", "type", "value", "timestamp"])
            writer.writerow([data["sensor_id"], data["type"], data["value"], data["timestamp"]])
        print(f"[CSV] logged : {data}")

class SQLFile(DataLogger):
    def log(self, data):
        with open("log.sql", "a", encoding="utf-8") as f:
            sql = (
                f"insert into sensor_logs (senser_id, type, value, timestamp) values ('{data['sensor_id']}', '{data['type']}', '{data['value']}', '{data['timestamp']}')"
            )
            f.write(sql)
        print(f"[SQL] logged : {data}")

class Sensor:
    def __init__(self, sensor_id: str, logger: DataLogger):
        self.sensor_id = sensor_id
        self.logger = logger
    
    def generate_random_value(self) -> float:
        raise NotImplementedError("this method must be implement")
    
    def get_sensor_type(self) -> str:
        raise NotImplementedError("this method must be implement")
    
    def record(self):
        value = self.generate_random_value()
        data = {
            "sensor_id": self.sensor_id,
            "type": self.get_sensor_type(),
            "value": value,
            "timestamp": datetime.now().isoformat()
        }
        self.logger.log(data)

class TemperatureSensor(Sensor):
    def generate_random_value(self):
        return round(random.uniform(22.0, 30.0), 2)
    
    def get_sensor_type(self):
        return "temperature"
    
class HumiditySensor(Sensor):
    def generate_random_value(self):
        return round(random.uniform(40.0, 60.0), 2)
    
    def get_sensor_type(self):
        return "humidity"
    

if __name__=="__main__":
    json_logger = JSONFile()
    csv_logger = CSVFile()
    sql_logger = SQLFile()

    temp_sensor = TemperatureSensor("t001", json_logger)
    humi_sensor = HumiditySensor("h001", csv_logger)

    for i in range(5):
        print(f"\n ครั้งที่ {i+1}")
        temp_sensor.record()
        humi_sensor.record()

        time.sleep(1)

    humi_sensor.logger = sql_logger
    humi_sensor.record()