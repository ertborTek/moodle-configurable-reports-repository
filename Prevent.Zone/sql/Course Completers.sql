-- -----------------------------------------------------------------------------
-- Course Completions
-- Context: Site
-- Name: Course Completers
-- Summary:
-- 	<h4>Students Completing Any Course</h4>
-- 	<h5>This includes the current and prior editions of this course.</h5>
-- Global: No
-- JavaScript Ordering: No
-- -----------------------------------------------------------------------------
SELECT
	u.username AS "Username",
	u.firstname AS "First Name",
	u.lastname AS "Last Name",
	u.email AS "E-mail",
	u.city AS "City",
	c.fullname AS "Course", 
	FROM_UNIXTIME(cc.timecompleted, '%Y-%m-%d') AS "Completed"

FROM prefix_course_completions AS cc

JOIN prefix_user AS u
ON cc.userid = u.id

JOIN prefix_course AS c
ON cc.course = c.id

WHERE TRUE
AND c.idnumber REGEXP '^[0-9]+'
AND cc.timecompleted IS NOT NULL
AND u.deleted = 0
AND u.email NOT LIKE "%@alivetek.com"
AND u.email NOT LIKE "%@prevent.zone"
%%FILTER_STARTTIME:cc.timecompleted:>%% %%FILTER_ENDTIME:cc.timecompleted:<%%

ORDER BY cc.timecompleted DESC
;
