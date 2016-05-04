# Call Centre

These data were retrieved as monthly zip files from http://ie.technion.ac.il/serveng/callcenterdata/index.html and then aggregated into a single CSV file.

This data set describes data recorded at the telephone call-center of a bank in Israel. The data were organized by Ilan Guedj, who was at the time a graduate student of the Faculty of
Industrial Engineering and Management at the Technion, Haifa.

The Internet site http://ie.technion.ac.il/~serveng contains a lot of material that is based on analysis of these present data.

## General Description

The call center provides several different services:
* Information on and transactions of checking and saving, to bank-customers
* Computer generated voice information (through VRU = Voice Response Unit)
* Information for prospective customers
* Support for the customers of the bank's web-site (internet customers)

The call center is comprised of:
* 8 agent positions,
* 1 shift-supervisor position,
* 5 agent positions for internet services (in an adjacent room).

During weekdays (Sunday to Thursday) the call center operates from 07:00 to 24:00. It closes at 14:00 on Friday and reopens at around 20:00 on Saturday. The automated service (VRU) operates 7 days a week, 24 hours a day. 

## Data Structure

The data archives all the calls handled by the call center, over the period of 12 months from 1 January and 31 December 1999.

The data are composed of a single record per phone call. Each record has 17 fields.

1. vru+line (6 digits): Each entering phone-call is first routed through a VRU: There are 6 VRUs labeled AA01 to AA06. Each VRU has several lines labeled 1-16. There are a total of 65 lines. Each call is assigned a VRU number and a line number.
2. Call_id (5 digits): Each entering call is assigned a call id. Although they are different, the id’s are not necessarily consecutive due to being assigned to different VRUs.
3. Customer_id (0 to 12 digits): This is the identification number of the caller, which identifies the customer uniquely; the ID is zero if the caller is not identified by the system (as is the case for prospective customers, for
example).
4. Priority (1 digit): The priority is taken from an off-line file. There are two types of customers:
	- 0 and 1 indicate unidentified customers or regular customers (to be elaborated on below)
	- 2 indicates priority customers
	- Customers are served in the order of their "Time in Queue".
	- Priority customers are allocated at the outset of their call 1.5 minutes of waiting-time (in order to advance their position in the queue.) They are also exempt from paying a NIS 7 monthly fee, which regular customers must pay.
	- Customers have not been told about the existence of priorities.
	- Until August 1996, all the customers had the same priority - 0. Priorities 1 and 2 were introduced in August 1st, 1996. There still are 0 priority customers, but they are treated as Priority 1. (As we understand it, priority 0 corresponds to those customers that were assigned priority 0 before August 1st and whose priority has not been upgraded.) 
	- Due to a system bug, customer I.D. was not recorded for those who did not wait in queue, hence, their priority is 0.
5. Type (2 digits): There are 6 different types of services:
	* PS - regular activity (coded 'PS' for 'Peilut Shotefet')
	* PE - regular activity in English (coded 'PE' for 'Peilut English')
	* IN - internet consulting (coded 'IN' for 'Internet')
	* NE -stock exchange activity (coded 'NE' for 'Niarot Erech')
	* NW - potential customer getting information
	* TT – customers who left a message asking the bank to return their call but, while the system returned their call, the calling-agent became busy hence the customers were put on hold in the queue.
6. Date (6 digit): year-month-day
7. vru_entry (6 digits): Time that the phone-call enters the call-center. More specifically, each calling customer must first be identified, which is done by providing the VRU with the customer-id. Hence this is the
time the call enters the VRU.
8. vru_exit (6 digits): Time of exit from the VRU: either to the queue, or directly to receive service, or to leave the system (abandonment).
9. vru_time (1 to 3 digits): Time (in seconds) spent in the VRU (calculated by exit_time – entry_time).
10. q_start (6 digits): Time of joining the queue (being put on “hold”). This entry is 00:00:00, for customers who have not reached the queue (abandoned from the VRU).
11. q_exit (6 digits): Time (in seconds) of exiting the queue: either to receive service or due to abandonment.
12. q_time (1 to 3 digits): Time spent in queue (calculated by q_exit – q_start)
13. Outcome (4,5 or 7 digits): There are 3 possible outcomes for each phone call: 
	* AGENT - service
	* HANG - hung up
	* PHANTOM - a virtual call to be ignored (unclear to us – fortunately, there are only few of these.)
14. ser_start (6 digits): Time of beginning of service by agent.
15. ser_exit (6 digits): Time of end of service by agent.
16. ser_time (1 to 3 digits): Service duration in seconds (calculated by ser_exit – ser_start).
17. Server (text): Name of the agent who served the call. This field is NO_SERVER, if no service was provided.