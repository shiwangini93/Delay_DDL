-- function

CREATE OR REPLACE FUNCTION public.drop_trigger()
 RETURNS event_trigger
 LANGUAGE plpgsql
AS $function$
declare

begin
	perform pg_sleep(600);	
end ; 
$function$ ;

