#pragma once

#include <string>

class ModStatics
{
public:
	ModStatics() {}
	~ModStatics() {}

	// Get current mod name
	static std::wstring GetModName() { return L"MotorTownMods"; }

	// Get current mod version
	static std::wstring GetVersion() { return L"0.40.0-rc1"; }

	// Get webhook URL for external callback
	static const std::string GetWebhookUrl();
};
