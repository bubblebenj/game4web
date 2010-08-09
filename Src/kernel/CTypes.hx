package kernel;

enum Result
{
	SUCCESS;
	FAILURE;
}

class Delegate
{
	public function Apply() : Result
	{
		return  SUCCESS;
	}
}