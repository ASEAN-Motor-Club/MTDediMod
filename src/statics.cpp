#include "statics.h"

const std::string ModStatics::GetWebhookUrl()
{
	const char* val = getenv("MOD_WEBHOOK_URL");
	return val ? std::string(val) : std::string();
}
