import psycopg2
import itertools


def task1(name, surname):
    cur = conn.cursor()
    cur.execute(
    """
    SELECT DISTINCT userid, name, surname FROM
        (userappointment JOIN usertb ON userappointment.userid = usertb.id) as temp
        JOIN appointment on temp.appointment = appointment.id
    WHERE
        ((name ~* '^[ml]' AND surname !~* '^[ml]')
        OR (name !~* '^[ml]' AND surname ~* '^[ml]'))
    AND role = 'Doctor'
    AND status = 'past'
    AND appointment.id IN
        (SELECT appointment.id FROM
            (userappointment JOIN usertb ON userappointment.userid = usertb.id) as temp
            JOIN appointment on temp.appointment = appointment.id
        WHERE name = %s AND surname = %s)
    AND date =
        (SELECT max(date) FROM
            (userappointment JOIN usertb ON userappointment.userid = usertb.id) as temp
            JOIN appointment on temp.appointment = appointment.id
        WHERE name = %s AND surname = %s)
    ;
    """, (name, surname, name, surname))
    print(cur.fetchall())


def task2():
    cur = conn.cursor()
    cur.execute(
    """
    SELECT
        userid,
        name,
        surname,
        EXTRACT(DOW FROM date)::INTEGER AS day_of_week,
        timeslotid,
        COUNT(*) AS total_appointments,
        (COUNT(*) / 52.0)::double precision AS average_appointments
    FROM
        (userappointment JOIN usertb ON userappointment.userid = usertb.id) as temp
        JOIN appointment on temp.appointment = appointment.id
    WHERE
        date > now() - INTERVAL '1 year'
    GROUP BY
        userid,
        name,
        surname,
        day_of_week,
        timeslotid
    ORDER BY
        userid ASC,
        day_of_week ASC,
        timeslotid ASC
    ;
    """
    )
    print(cur.fetchall())


if __name__ == "__main__":
    pwd = input("Password: ")
    conn = psycopg2.connect(host = "localhost",
                            database = "phase3",
                            user = "postgres",
                            password = pwd)
    #task1("Anna", "Smith")
    task2()
    conn.close()
    
