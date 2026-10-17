"""Sign in to a personal Planova account."""

import from ..components.AccountAccess { AccountAccess }

def:pub LoginPage -> JsxPage {
    <AccountAccess />
}
