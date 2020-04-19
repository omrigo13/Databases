import sqlite3
from datetime import date
import csv # Use this to read the csv file


def create_connection(db_file):
    """ create a database connection to the SQLite database
        specified by the db_file

    Parameters
    ----------
    Connection
    """
    Connection = sqlite3.connect(db_file)
    return Connection
    pass


def update_employee_salaries(conn, increase):
    """

    Parameters
    ----------
    conn: Connection
    increase: float
    """
    c = conn.cursor()
    increase = (100+increase)/100
    result = 'UPDATE ConstructorEmployee SET SalaryPerDay = SalaryPerDay * ?' \
             'WHERE ConstructorEmployee.EID in (SELECT EID FROM ConstructorEmployeeOverFifty)'
    c.execute(result,(increase,))
    pass

def get_employee_total_salary(conn):
    """
    Parameters
    ----------
    conn: Connection

    Returns
    -------
    int
    """
    c = conn.cursor()
    result = c.execute('SELECT SUM(SalaryPerDay) FROM ConstructorEmployee')
    return result.fetchone()[0]
    pass


def get_total_projects_budget(conn):
    """
    Parameters
    ----------
    conn: Connection

    Returns
    -------
    float
    """
    c = conn.cursor()
    result = c.execute('SELECT SUM(Budget) FROM Project')
    return result.fetchone()[0]
    pass


def calculate_income_from_parking(conn, year):
    """
    Parameters
    ----------
    conn: Connection
    year: int

    Returns
    -------
    float
    """
    c = conn.cursor()
    result = "SELECT SUM(Cost) FROM CarParking WHERE strftime('%Y', StartTime) = ?"
    result = c.execute(result,(year,))
    return result.fetchone()[0]
    pass


def get_most_profitable_parking_areas(conn):
    """
    Parameters
    ----------
    conn: Connection

    Returns
    -------
    list[tuple]

    """
    c = conn.cursor()
    result = 'SELECT AID as ParkingAreaID, SUM(Cost) AS Income FROM CarParking GROUP BY AID ' \
             ' ORDER BY Income DESC , AID DESC LIMIT 5;'
    result = c.execute(result)
    result = result.fetchall()
    return result
    pass


def get_number_of_distinct_cars_by_area(conn):
    """
    Parameters
    ----------
    conn: Connection

    Returns
    -------
    list[tuple]

    """
    c = conn.cursor()
    result = 'SELECT ParkingArea.AID, count(DISTINCT CarParking.CID) AS CarsNumber FROM ParkingArea, CarParking' \
             ' WHERE CarParking.AID = ParkingArea.AID GROUP BY ParkingArea.AID ORDER BY CarsNumber DESC'
    result = c.execute(result)
    return result.fetchall()
    pass

def add_employee(conn, eid, firstname, lastname, birthdate, street_name, number, door, city):
    """
    Parameters
    ----------
    conn: Connection
    eid: int
    firstname: str
    lastname: str
    birthdate: datetime
    street_name: str
    number: int
    door: int
    city: str
    """
    c = conn.cursor()
    result = 'INSERT INTO [Employee] VALUES (?,?,?,?,?,?,?,?)'
    c.execute(result,(eid,firstname,lastname,birthdate,street_name,number,door,city))
    conn.commit()
    pass

def load_neighborhoods(conn, csv_path):
    """

    Parameters
    ----------
    conn: Connection
    csv_path: str
    """
    file = open(csv_path)
    c = conn.cursor()
    for row in file:
        s = "INSERT INTO [Neighborhood] ([NID], [Name]) VALUES (?, ?)"
        c.execute(s, (row[0], row[2:]))
    pass