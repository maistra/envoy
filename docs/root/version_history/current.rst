1.20.4 (Pending)
1.22.1 (Pending)
================
1.22.4 (Pending)
======================
1.22.7 (Pending)
================
1.22.10 (Pending)
=================

Incompatible Behavior Changes
-----------------------------
*Changes that are expected to cause an incompatibility if applicable; deployment changes are likely required*

* http: validate upstream request header names and values. The new runtime flag ``envoy.reloadable_features.validate_upstream_headers`` can be used for revert this behavior.

Minor Behavior Changes
----------------------
*Changes that may cause incompatibilities for some users, but should not for most*

* cryptomb: remove RSA PKCS1 v1.5 padding support.
* tls: if both :ref:`match_subject_alt_names <envoy_v3_api_field_extensions.transport_sockets.tls.v3.CertificateValidationContext.match_subject_alt_names>` and :ref:`match_typed_subject_alt_names <envoy_v3_api_field_extensions.transport_sockets.tls.v3.CertificateValidationContext.match_typed_subject_alt_names>` are specified, the former (deprecated) field is ignored. Previously, setting both fields would result in an error.

Bug Fixes
---------
*Changes expected to improve the state of the world and are unlikely to have negative effects*

* oauth: fixed a bug where the oauth2 filter would crash if it received a redirect URL without a state query param set.

Removed Config or Runtime
-------------------------
*Normally occurs at the end of the* :ref:`deprecation period <deprecated>`

New Features
------------

Deprecated
----------
