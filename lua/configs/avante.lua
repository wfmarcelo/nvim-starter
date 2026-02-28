return {
  provider = "copilot",
  auto_suggestions_provider = "copilot",
  providers = {
    copilot = {
      model = "gpt-4o-2024-08-06",
      extra_request_body = {
        max_tokens = 4096,
      },
    },
  },
}
