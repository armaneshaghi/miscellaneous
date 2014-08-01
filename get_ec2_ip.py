#!/usr/bin/python                                                                                                                                              
import boto.ec2
ec2_conn = boto.ec2.connect_to_region('us-east-1')
reservations = ec2_conn.get_all_reservations()
reservation = reservations[0]
instance = reservation.instances[0]
print instance.ip_address
