This document will have various fundational information related to doing dfir, some topics may get their own docuemnts but majority of the fundation info are to be found within this one, if another document is used, then this document will note such.

-----


INDEX:

+ The six main phases of IR process
+ IR Framework


----

## The six main phases of IR process

IR process can mainly be broadly broken down into six main processes which each have a set of actions a organization can take to address a incident, these are as follows:

+ Preparation: 
    Without good preparation, any subsequent incident response is going to be disorganized and has the potential to make the incident worse. One of the critical components of preparation is the creation of an incident response plan. Once a plan is in place with the necessary staffing, ensure that personnel detailed with incident response duties are properly trained. This includes processes, procedures, and any additional tools necessary for the investigation of an incident. In addition to the plan, tools such as forensics hardware and software should be acquired and incorporated into the overall process. Finally, regular exercises should be conducted to ensure that the organization is trained and familiar with the process.

+ Detection:
    The detection of potential incidents is a complex endeavor. Depending on the size of the organization, they may have over 100 million separate events per day. These events can be records of legitimate actions taken during the normal course of business or be indicators of potentially malicious activity. Couple this mountain of event data with other security controls constantly alerting to activity and you have a situation where analysts are inundated with data and must subsequently sift out the valuable pieces of signal from the vastness of network noise. Even today's cutting-edge Security Incident and Event Management (SIEM) tools lose their effectiveness if they are not properly maintained with regular updates of rule sets that identify what events qualify as a potential incident. The detection phase is that part of the incident response process where the organization first becomes aware of a set of events that possibly indicates malicious activity. This event, or events, that have been detected and are indicative of malicious behavior are then classified as an incident. For example, a security analyst may receive an alert that a specific administrator account was in use during the time where the administrator was on vacation. Detection may also come from external sources. An ISP or law enforcement agency may detect malicious activity originating in an organization's network and contact them and advise them of the situation.

    In other instances, users may be the first to indicate a potential security incident. This may be as simple as an employee contacting the help desk and informing a help desk technician that they received an Excel spreadsheet from an unknown source and opened it. They are now complaining that their files on the local system are being encrypted. In each case, an organization would have to escalate each of these events to the level of an incident and begin the reactive process to investigate and remediate.

+ Analysis:
    Once an incident has been detected, personnel from the organization or a trusted third party will begin the analysis phase. In this phase, personnel begin the task of collecting evidence from systems such as running memory, log files, network connections, and running software processes. Depending on the type of incident, this collection can take as little as a few hours to several days. Once the evidence is collected, it then needs be examined. There are a variety of tools to conduct this analysis, With these tools, analysts are attempting to ascertain what happened, what it affected, whether any other systems were involved, and whether any confidential data was removed. The ultimate goal of the analysis is to determine the root cause of the incident and reconstruct the actions of the threat actor from initial compromise to detection.

+ Containment: 
    Once there is a solid understanding of what the incident is and what systems are involved, organizations can then move into the containment phase. In this phase, organizations take measures to limit the ability for threat actors to continue compromising other network resources, communicating with command and control infrastructures, or exfiltrating confidential data. Containment strategies can range from locking down ports and IP addresses on a firewall to simply removing the network cable from the back of an infected machine. Each type of incident involves its own containment strategy, but having several options allows personnel to stop the bleeding at the source if they are able to detect a security incident before or during the time when threat actors are pilfering data.

+ Eradication and recovery:
    During the eradication phase, the organization removes the threat actor from the impacted network. In the case of a malware infection, the organization may run an enhanced anti-malware solution. Other times, infected machines must be wiped and reimaged. Other activities include removing or changing compromised user accounts. If an organization has identified a vulnerability that was exploited, vendor patches are applied, or software updates are made. Recovery activities are very closely aligned with those that may be found in an organization's business continuity or disaster recovery plans. In this phase of the process, organizations reinstall fresh operating systems or applications. They will also restore data on local systems from backups. As a due diligence step, organizations will also audit their existing user and administrator accounts to ensure that there are no accounts that have been enabled by threat actors. Finally, a comprehensive vulnerability scan is conducted so that the organization is confident that any exploitable vulnerabilities have been removed.

+ Post-incident activity:

    At the conclusion of the incident process is a complete review of the incident with all the principle stakeholders. Post-incident activity includes a complete review of all the actions taken during the incident. What worked, and more importantly, what did not work, are important topics for discussion. These reviews are important because they may highlight specific tasks and actions that had either a positive or negative impact on the outcome of the incident response. It is during this phase of the process that a written report is completed. Documenting the actions taken during the incident is critical to capture both what occurred and whether the incident will ever see the inside of a courtroom. For documentation to be effective, it should be detailed and show a clear chain of events with a focus on the root cause, if it was determined. Personnel involved in the preparation of this report should realize that stakeholders outside of information technology might read this report. As a result, technical jargon or concepts should be explained.

The organizational personnel should update their own incident response processes with any new information developed during the post-incident debrief and reporting. This incorporation of lessons learned is important as it makes future responses to incidents more effective.

## IR framework

As doing IR response "ad-hoc" is never a good idea as it can easily create issues both in dealing with the incident and the aftermath(both legally and not), a framework on how to perform a IR that utilizing a organizations available resources are important to be made so everything can happen both quickly and properly with as little problems as possible.

A IR framework is made up of different elements which includes but not limited to 
+ Personnel
+ policies
+ procedures


### IR Charter

The IR charter outlines key elements that will drive the creation of a Computer Security Incident Response Team(CSIRT)/Computer Emengency Response Team(CERT).

The incident response charter should be a written document that addresses the following:

+ Obtain senior leadership support: 
    In order to be a viable part of the organization, the CSIRT requires the support of the senior leadership within the organization. In a private sector institution, it may be difficult to obtain the necessary support and funding, as the CSIRT itself does not provide value in the same way marketing or sales does. What should be understood is that the CSIRT acts as an insurance policy in the event the worst happens. In this manner, a CSRIT can justify its existence by reducing the impact of incidents and thereby reducing the costs associated with a security breach or other malicious activity.

+ Define the constituency:
    The constituency clearly defines which organizational elements and domains the CSIRT has responsibility for. Some organizations have several divisions or subsidiaries that for whatever reason may not be part of the CSIRT's responsibility. The constituency can be defined either as a domain such as local.example.com or an organization name such as ACME Inc. and associated subsidiary organizations.

+ Create a mission statement: 
    Mission creep or the gradual expansion of the CSIRT's responsibilities can occur without clear definition of what the defined purpose of the CSIRT is. In order to counter this, a clearly defined mission statement should be included with the written information security plan. For example, 
    
    `the mission of the ACME Inc. CSIRT is to provide timely analysis and actions for security incidents that impact the confidentiality, integrity, and availability of ACME Inc. information systems and personnel`.

+ Determine service delivery:
    Along with a mission statement, a clearly defined list of services can also counter the risk of mission creep of the CSIRT. Services are usually divided into two separate categories, proactive and reactive services:
    
    **Proactive services**: These include providing training for non- CSIRT staff, providing summaries on emerging security threats, testing and deployment of security tools such as endpoint detection and response tools, and assisting security operations by crafting IDS/IPS alerting rules. 
    
    **Reactive services**: These primarily revolve around responding to incidents as they occur. For the most part, reactive services address the entire incident response process. This includes the acquisition and examination of evidence, assisting in containment, eradication, and recovery efforts, and finally documenting the incident.


Another critical benefit of an expressly stated charter is to socialize the CSIRT with the
entire organization. This is done to remove any rumors or innuendo about the purpose of
the team. Employees of the organization may hear words such as digital investigations or
incident response team and believe the organization is preparing a secret police specifically
designed to ferret out employee misconduct. To counter this, a short statement that
includes the mission statement of the CSIRT can be made available to all employees. The
CSIRT can also provide periodic updates to senior leadership on incidents handled to
demonstrate the purpose of the team.

## CSIRT

## technical support personnel

## Organizational support personnel

## The incident response plan


## External resources


