-- -----------------------------------------------------------------------------
-- Course Completions for All Courses (with custom fields)
-- Context: Site
-- Name: Course Completers †
-- Summary:
-- 	<h4>Students Completing any Course</h4>
-- 	<h5>This includes current and prior editions of any course.</h5>
-- 	<br>
-- 	<p>To see completions for a specific time period, apply a <b>Start</b> and <b>End</b> date.</p>
-- Global: No
-- JavaScript Ordering: No
-- -----------------------------------------------------------------------------
SELECT
	u.username AS "Username",
	pzu.first_name AS "First Name",
	pzu.last_name AS "Last Name",
	pzu.email AS "E-mail",
	pzu.student_id AS "Student ID",
	pzu.student_id AS "Student Number",
	pzu.campus AS "Campus",
	pzuo.name AS "Organization",
	pzuo.type AS "Organization Type",
	pzuo.council AS "Council",
	pzuo.position AS "Position",
	pzu.classification AS "Classification",
	pzu.graduation AS "Graduation",
	pzu.major AS "Major",
	pzu.residency AS "Residency",
	pzu.city AS "City",
	pzu.state AS "State",
	pzu.zip_code AS "ZIP Code",
	c.fullname AS "Course", 
	FROM_UNIXTIME(cc.timecompleted, '%Y-%m-%d') AS "Completed"

FROM prefix_course_completions AS cc

JOIN prefix_user AS u
ON cc.userid = u.id

JOIN prefix_course AS c
ON cc.course = c.id

JOIN prevent_zone.user_lms_accounts AS pzula
ON cc.userid = pzula.moodle_id

JOIN prevent_zone.users AS pzu
ON pzula.user_id = pzu.user_id

LEFT JOIN prevent_zone.user_organizations AS pzuo
ON pzu.user_id = pzuo.user_fk

WHERE TRUE
AND pzu.institution = REGEXP_REPLACE("%%WWWROOT%%", "https{0,1}://([^.]+)\\.[^.]+\\.[^.]+(/[^/]+)*", "\\1")
AND c.idnumber REGEXP '^[0-9]+'
AND cc.timecompleted IS NOT NULL
AND u.deleted = 0
AND u.email NOT LIKE "%@alivetek.com"
AND u.email NOT LIKE "%@prevent.zone"
%%FILTER_STARTTIME:cc.timecompleted:>%% %%FILTER_ENDTIME:cc.timecompleted:<%%

ORDER BY cc.timecompleted DESC
;
