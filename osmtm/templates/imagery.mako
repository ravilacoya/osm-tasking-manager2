<%
  # FIXME already done in base.mako
  from pyramid.security import authenticated_userid
  from osmtm.models import DBSession, User
  username = authenticated_userid(request)
  license_accepted = None
  if username is not None:
    user = DBSession.query(User).get(username)
    if user is not None:
      license_accepted = project.license in user.accepted_licenses
  else:
    user = None
%>
% if project.imagery is not None and project.imagery != 'None':
% if license_accepted or not project.license:
<%
    type = project.imagery.lower()[:3]
%>
<p>
  ${project.imagery}
</p>
<p>
  <a href='http://127.0.0.1:8111/imagery?title=${project.name}&type=${type}&url=${project.imagery}'
    class="btn btn-default btn-xs"
    target="_blank" rel="tooltip"
    data-original-title="${_('If you have JOSM running and remote control activated, clicking this link should automatically load imagery.')}">
    <span class="glyphicon glyphicon-share-alt"></span>
    JOSM
  </a>
  <a
    class="btn btn-default btn-xs"
    rel="tooltip"
    data-original-title="${_('Imagery should load automatically when you will open a task using the iD Editor')}">
    <span class="glyphicon glyphicon-share-alt"></span>
    iD Editor
  </a>
</p>
% elif not license_accepted:
<p>
  tms[22]:http://xxx.xxxx.com/hot/1.0.0/xxxxxx/{zoom}/{x}/{y}.png
</p>
% endif
% if project.license:
<%
  license_agreement_url = request.route_path('license', license=project.license.id, \
      _query={'redirect': request.route_path('project', project=project.id)})
%>
<p class="text-warning">
  <span class="glyphicon glyphicon-warning-sign"></span>
  Access to this imagery is limited by the
  <a href="${license_agreement_url}">
    ${project.license.name} license agreement
  </a>.
</p>
<p class="${'text-error' if not license_accepted else 'text-success'}">
% if license_accepted:
  <span class="glyphicon glyphicon-ok"></span>
You have already acknowledged the terms of this license.</span>
% else:
  You need to
  <a href="${license_agreement_url}">
    review and acknowledge
  </a>
  the agreement.
  <script>
    var licenseAgreementUrl = "${license_agreement_url}";
    var requiresLicenseAgreementMsg = "${_('You need to accept the license first') |n}"
  </script>
% endif
</p>
% endif
% endif
