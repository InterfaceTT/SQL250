USE AdventureWorks;

SELECT E.EmployeeID
, C.LastName
, E.HireDate
, vje.[Edu.Degree]
FROM HumanResources.Employee AS E
INNER JOIN Person.Contact AS C
ON E.ContactID = C.ContactID
LEFT JOIN HumanResources.JobCandidate AS JC
ON e.EmployeeID = jc.EmployeeID
LEFT JOIN HumanResources.vJobCandidateEducation AS VJE
ON jc.JobCandidateID = VJE.JobCandidateID
WHERE E.Gender = 'm'
AND (E.HireDate BETWEEN '20010101' AND '20011231'
OR e.HireDate BETWEEN '20030101' AND '20031231')
AND vje.[Edu.Degree]  IS NOT NULL;