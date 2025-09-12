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

## Recharge methods template

Configure "Recharge Methods" using the following structure:

```json
[
  {
    "color": "rgba(var(--semi-blue-5), 1)",
    "name": "支付宝",
    "type": "alipay"
  },
  {
    "color": "rgba(var(--semi-green-5), 1)",
    "name": "微信",
    "type": "wxpay"
  },
{
		"name":      "自定义1",
		"color":     "black",
		"type":      "custom1",
		"min_topup": "50"
	}
]
```

### Field reference

- name: Display label shown on the "Choose payment method" button (e.g., Alipay/WeChat/Stripe/Custom1).
- color: Button/badge theme or border color. Accepts any CSS color; using design tokens like `rgba(var(--semi-blue-5), 1)` is recommended.
- type: Channel identifier used by the backend to route the order request.
  - `stripe` → handled by Stripe gateway.
  - Others (e.g., `alipay`, `wxpay`, `custom1`) → handled by an EPay‑style gateway, passing the value as the channel.
  - See controller `controller/topup.go` for details: [controller/topup.go](https://github.com/QuantumNous/new-api/blob/main/controller/topup.go).
- min_topup: Minimum allowed amount for this method. If the input amount is below it, the UI shows a tooltip and blocks payment; the backend validates as well.
- Order: Methods render left‑to‑right in the array order.