"""Create a personal Planova account."""

import from ..components.AccountAccess { AccountAccess }

def:pub SignupPage -> JsxPage {
    <AccountAccess register={True} />
}
