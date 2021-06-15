Telemetry Data Points
    ● Process creation
    ● File creation, modification, and deletion
    ● Registry key creation, modification, and deletion (Windows)
    ● Registry value creation, modification, and deletion (Windows)

**Assignment Instructions **

Generate endpoint activity across Windows, macOS, Linux. 
    ● Start a process, given a path to an executable file and the desired (optional) command-line arguments
    ● Create a file of a specified type at a specified location
    ● Modify a file
    ● Delete a file
    ● Establish a network connection and transmit data

    Keep a log of the activity it triggered (CSV, TSV, JSON, YAML, etc). 
    ● Process start
        ○ Timestamp of start time
        ○ Username that started the process
        ○ Process name
        ○ Process command line
        ○ Process ID

    ● File creation, modification, deletion
        ○ Timestamp of activity
        ○ Full path to the file
        ○ Activity descriptor - e.g. create, modified, delete
        ○ Username that started the process that created/modified/deleted the file 
        ○ Process name that created/modified/deleted the file
        ○ Process command line
        ○ Process ID

    ● Network connection and data transmission
        ○ Timestamp of activity
        ○ Username that started the process that initiated the network activity 
        ○ Destination address and port
        ○ Source address and port
        ○ Amount of data sent
        ○ Protocol of data sent
        ○ Process name
        ○ Process command line
        ○ Process ID

Include README doc describing what you’ve created and how it works.

Final Deliverables
    ● The coding project as outlined above in the “Assignment” section.
    ● Brief one page document describing the project and how it works.

    **You’re free to ask questions and brainstorm with Red Canary engineers. You do not have to solve this in a vacuum but you will have to write all code yourself.**
