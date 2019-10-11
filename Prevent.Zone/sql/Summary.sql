-- -----------------------------------------------------------------------------
-- Course Completion Summary for All Courses
-- Context: Site
-- Name: Course Completion Summary
-- Summary: 
-- 	<h4>Completion Status Summary by Course</h4>
-- 	<h5>This includes the current and prior editions of all courses.</h5>
-- Global: No
-- JavaScript Ordering: No
-- -----------------------------------------------------------------------------
SELECT
	c.fullname AS "Course",
	SUM( IF(cc.timecompleted IS NULL, 0, 1) ) AS "Complete",
	SUM( IF(cc.timecompleted IS NULL, 1, 0) ) AS "Incomplete",
	COUNT(*) AS "Total"

FROM prefix_course_completions AS cc

JOIN prefix_user AS u
ON cc.userid = u.id

JOIN prefix_course AS c
ON cc.course = c.id

WHERE true
AND c.idnumber REGEXP '[0-9]{3}(-[0-9]{4}){0,1}$'
AND u.deleted = 0
AND email NOT LIKE '%@alivetek.com'
AND email NOT LIKE '%@prevent.zone'
AND username NOT LIKE '%@alivetek.com'
%%FILTER_STARTTIME:cc.timecompleted:>%% %%FILTER_ENDTIME:cc.timecompleted:<%%

GROUP BY c.fullname

ORDER BY c.sortorder
;
