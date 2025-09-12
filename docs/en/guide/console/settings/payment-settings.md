# Payment Settings

Here you can configure settings related to the recharge/payment features.

![Payment Settings](../../../assets/guide/payment-setting.png)

![Stripe](../../../assets/guide/stripe.png)

## Supported payment gateways

- **EPay**
  - Required: `API Base URL`, `Merchant ID (PID)`, `Merchant Key (KEY)`
  - The platform sends a signed callback; the system verifies and credits automatically
- **Stripe (optional)**
  - Required: `Secret Key` `WebHook Signing Secret` `Product Price ID`

The actual available fields are subject to the form on this page. Save to enable recharge on the Wallet page.

## What is EPay

**EPay (Yipay/EasyPay/EPay)** is a generic term for a "third‑party aggregated payment gateway/interface" pattern, not any specific website or company.

- **Core role**: Aggregate channels such as WeChat Pay, Alipay, and bank cards, and provide unified order creation, signature verification, and callback interfaces to merchants.
- **Common fields**: `out_trade_no`, `amount`, `subject`, `notify_url`, `return_url`; usually signed with merchant `PID/KEY` or certificates (e.g., MD5/HMAC/RSA).
- **Forms**: Can refer to commercial aggregation services or self‑hosted/open‑source gateways that follow an "EPay‑style" protocol.
- **Use cases**: One integration to access multiple channels and go live quickly for SMBs or multi‑client apps.
- **Compliance note**: The gateway itself is not a licensed payment institution; settlement and compliance rely on the connected licensed channels. Follow local regulations and risk controls.