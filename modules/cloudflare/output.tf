output "api_tokens" {
  value = {
    for token_name, token_obj in module.api_tokens :
    token_name => token_obj.auth_token
  }
}

output "pages" {
  value = {
    for page_name, page_obj in module.pages :
    page_name => page_obj.cloudflare_page
  }
}
