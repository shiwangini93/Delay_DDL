-- event trigger

CREATE EVENT TRIGGER trigger_for_drops ON sql_drop
	EXECUTE FUNCTION public.drop_trigger();
