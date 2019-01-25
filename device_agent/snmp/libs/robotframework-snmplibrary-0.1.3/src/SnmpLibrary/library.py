# Copyright 2014-2015 Kontron Europe GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os.path
import warnings
import time
from itertools import islice
try:
    from itertools import izip
except ImportError:
    izip = zip
from robot.utils.connectioncache import ConnectionCache

with warnings.catch_warnings():
    warnings.filterwarnings("ignore", category=DeprecationWarning)
    from pysnmp.smi import builder, view
    from pysnmp.entity import engine, config
    from pysnmp.entity.rfc3413.oneliner import cmdgen
    from pyasn1.type import univ
    from pysnmp.proto import rfc1902, rfc1905
    from pysnmp.smi.rfc1902 import ObjectIdentity
    
from .traps import _Traps
from . import utils
from . import __version__

class _SnmpConnection:

    def __init__(self, authentication, transport_target):
        eng = engine.SnmpEngine()
        self.builder = eng.msgAndPduDsp.mibInstrumController.mibBuilder

        self.cmd_gen = cmdgen.CommandGenerator(eng)
        self.authentication_data = authentication
        self.transport_target = transport_target

        self.prefetched_table = {}

    def close(self):
        # nothing to do atm
        pass

class SnmpLibrary(_Traps):
    AGENT_NAME = 'robotframework agent'
    ROBOT_LIBRARY_VERSION = __version__
    ROBOT_LIBRARY_SCOPE = 'TEST SUITE'
    DTM_MIB_LIB_NAME = 'DTM-TD-LTE-ENODEB-ENBMIB'

    def __init__(self):
        _Traps.__init__(self)
        self._active_connection = None
        self._cache = ConnectionCache()

    def open_snmp_v2c_connection(self, host, community_string=None, port=161,
            timeout=2.0, retries=5, alias=None):
        """Opens a new SNMP v2c connection to the given host.

        Set `community_string` that is used for this connection.

        If no `port` is given, the default port 161 is used.

        The connection `timeout` and `retries` can be configured.

        The optional `alias` is a name for the connection and it can be used
        for switching between connections, similarly as the index. See `Switch
        Connection` for more details about that.
        """

        host = str(host)
        port = int(port)
        timeout = float(timeout)
        retries = int(retries)

        if alias:
            alias = str(alias)

        authentication_data = cmdgen.CommunityData(self.AGENT_NAME,
                                       community_string)
        transport_target = cmdgen.UdpTransportTarget(
                                        (host, port), timeout, retries)

        connection = _SnmpConnection(authentication_data, transport_target)
        self._active_connection = connection

        return self._cache.register(self._active_connection, alias)

    # backwards compatibility, will be removed soon
    open_snmp_connection = open_snmp_v2c_connection

    def open_snmp_v3_connection(self, host, user, password='',
            encryption_password=None, authentication_protocol=None,
            encryption_protocol=None, port=161,
            timeout=1.0, retries=5, alias=None):
        """Opens a new SNMP v3 Connection to the given host.

        If no `port` is given, the default port 161 is used.

        Valid values for `authentication_protocol` are `MD5`, `SHA`, and None.
        Valid values for `encryption_protocol` are `DES`,`3DES`, `AES128`,
        `AES192`, `AES256` and None.

        The optional `alias` is a name for the connection and it can be used
        for switching between connections, similarly as the index. See `Switch
        Connection` for more details about that.
        """

        host = str(host)
        port = int(port)
        user = str(user)
        timeout = float(timeout)
        retries = int(retries)

        if password is not None:
            password = str(password)

        if encryption_password is not None:
            encryption_password = str(encryption_password)

        if alias:
            alias = str(alias)

        if authentication_protocol is not None:
            authentication_protocol = authentication_protocol.upper()

        try:
            authentication_protocol = {
                None: cmdgen.usmNoAuthProtocol,
                'MD5': cmdgen.usmHMACMD5AuthProtocol,
                'SHA': cmdgen.usmHMACSHAAuthProtocol
            }[authentication_protocol]
        except KeyError:
            raise RuntimeError('Invalid authentication protocol %s' %
                                                    authentication_protocol)

        if encryption_protocol is not None:
            encryption_protocol = encryption_protocol.upper()

        try:
            encryption_protocol = {
                None: cmdgen.usmNoPrivProtocol,
                'DES': cmdgen.usmDESPrivProtocol,
                '3DES': cmdgen.usm3DESEDEPrivProtocol,
                'AES128': cmdgen.usmAesCfb128Protocol,
                'AES192': cmdgen.usmAesCfb192Protocol,
                'AES256': cmdgen.usmAesCfb256Protocol,
            }[encryption_protocol]
        except KeyError:
            raise RuntimeError('Invalid encryption protocol %s' %
                                                    encryption_protocol)

        authentication_data = cmdgen.UsmUserData(
                                    user,
                                    password,
                                    encryption_password,
                                    authentication_protocol,
                                    encryption_protocol)

        transport_target = cmdgen.UdpTransportTarget(
                                        (host, port), timeout, retries)

        conn = _SnmpConnection(authentication_data, transport_target)
        self._active_connection = conn

        return self._cache.register(self._active_connection, alias)

    def close_snmp_connection(self):
        """Closes the current connection.
        """
        self._active_connection.close()
        self._active_connection = None

    def close_all_snmp_connections(self):
        """Closes all open connections and empties the connection cache.

        After this keyword, new indexes got from the `Open Connection`
        keyword are reset to 1.

        This keyword should be used in a test or suite teardown to
        make sure all connections are closed.
        """

        self._active_connection = self._cache.close_all()
        self._active_connection = None

    def switch_snmp_connection(self, index_or_alias):
        """Switches between active connections using an index or alias.

        The index is got from `Open Connection` keyword, and an alias
        can be given to it.

        Returns the index of previously active connection.
        """

        old_index = self._cache.current_index
        self._active_connection = self._cache.switch(index_or_alias)
        return old_index

    def add_mib_search_path(self, path):
        """Adds a path to the MIB search path.

        Example:
        | Add MIB Search Path | /usr/share/mibs/ |
        """

        self._info('Adding MIB path %s' % (path,))
        if not os.path.exists(path):
            raise RuntimeError('Path "%s" does not exist' % path)

        paths = self._active_connection.builder.getMibPath()
        paths += (path, )
        self._debug('New paths: %s' % ' '.join(paths))
        self._active_connection.builder.setMibPath(*paths)

    def preload_mibs(self, *names):
        """Preloads MIBs.

        Preloading MIBs can be useful in cases where the `Get`- or
        `Set`-keyword should be executed as fast as possible.

        `names` can either be a list of MIB names or can be empty in which case
        all available MIBs are preloaded.

        This keyword should be used within the test setup.

        Note: Preloading all MIBs take a long time.
        """
        if len(names):
            self._info('Preloading MIBs %s' % ' '.join(list(names)))
        else:
            self._info('Preloading all available MIBs')
        self._active_connection.builder.loadModules(*names)
        
    def load_mib(self, *names):
        """loads MIBs.

        Preloading MIBs can be useful in cases where the `Get`- or
        `Set`-keyword should be executed as fast as possible.

        `names` can either be a list of MIB names or can be empty in which case
        all available MIBs are preloaded.

        This keyword should be used within the test setup.

        Note: Preloading all MIBs take a long time.
        """
        if len(names):
            self._info('loading MIB %s' % ' '.join(list(names)))
            self._active_connection.builder.loadModule(*names)
        else:
            self._info('Preloading no MIBs')
        
    def get_oid_by_name(self, *names):
        """get oid from custom names.

        """
        if len(names):
            self._info('get_oid_by_name %s' % ' '.join(list(names)))
            mibViewCtl = view.MibViewController(self._active_connection.builder)
            objIdentity = ObjectIdentity(*names)
            objIdentity.resolveWithMib(mibViewCtl)
            return '.' +  str(objIdentity.getOid())

    def get_value_by_name(self, *names):
        """get value from custom names direcly.

        """
        if len(names):
            self._info('get_oid_by_name %s' % ' '.join(list(names)))
            mibViewCtl = view.MibViewController(self._active_connection.builder)
            objIdentity = ObjectIdentity(*names)
            objIdentity.resolveWithMib(mibViewCtl)
            oid = '.' +  str(objIdentity.getOid())
            return self._get(oid)

    def get_value_by_name2(self, idx, *names):
        """get value from custom names direcly.

        """
        if len(names):
            self._info('get_oid_by_name %s' % ' '.join(list(names)))
            mibViewCtl = view.MibViewController(self._active_connection.builder)
            objIdentity = ObjectIdentity(*names)
            objIdentity.resolveWithMib(mibViewCtl)
            oid = '.' + str(idx) + '.' +  str(objIdentity.getOid())
            return self._get(oid)
                 
    def _get(self, oid, idx=(0,), expect_display_string=False):

        if self._active_connection is None:
            raise RuntimeError('No transport host set')

        idx = utils.parse_idx(idx)
        oid = utils.parse_oid(oid) + idx

        error_indication, error, _, var = \
            self._active_connection.cmd_gen.getCmd(
                self._active_connection.authentication_data,
                self._active_connection.transport_target,
                oid
        )

        if error_indication is not None:
            raise RuntimeError('SNMP GET failed: %s' % error_indication)
        if error != 0:
            raise RuntimeError('SNMP GET failed: %s' % error.prettyPrint())

        oid, obj = var[0]

        if isinstance(obj, rfc1905.NoSuchInstance):
            raise RuntimeError('Object with OID %s not found' %
                    utils.format_oid(oid))

        if expect_display_string:
            if not univ.OctetString().isSuperTypeOf(obj):
                raise RuntimeError('Returned value is not an octetstring')
            value = obj.prettyOut(obj)
        elif univ.OctetString().isSuperTypeOf(obj):
            value = obj.asNumbers()
        else:
            value = obj.prettyOut(obj)

        self._info('OID %s has value %s' % (utils.format_oid(oid), value))

        return value
#majingwei 2018/10/12
    # def getNext(self, oid, idx=(0,), expect_display_string=False):
    #     if self._active_connection is None:
    #         raise RuntimeError('No transport host set')

    #     idx = utils.parse_idx(idx)
    #     oid = utils.parse_oid(oid) + idx

    #     error_indication, error, _, var = \
    #         self._active_connection.cmd_gen.nextCmd(
    #             self._active_connection.authentication_data,
    #             self._active_connection.transport_target,
    #             oid
    #     )
    #     self._info(str(type(var)))
    #     for oid, obj in var:            
    #         self._info(str(oid))
    #         self._info(str(obj))
    #     if error_indication is not None:
    #         raise RuntimeError('SNMP GET failed: %s' % error_indication)
    #     if error == 342:
    #         return 342
    #     if error != 0:
    #         raise RuntimeError('SNMP GET failed: %s' % error.prettyPrint())
    #     value_list = list()
    #     #oid, obj = var[0]
    #     for oid, obj in var:  
    #         if isinstance(obj, rfc1905.NoSuchInstance):
    #             raise RuntimeError('Object with OID %s not found' %
    #                     utils.format_oid(oid))
    #         if expect_display_string:
    #             if not univ.OctetString().isSuperTypeOf(obj):
    #                 raise RuntimeError('Returned value is not an octetstring')
    #             value = obj.prettyOut(obj)
    #         elif univ.OctetString().isSuperTypeOf(obj):
    #             value = obj.asNumbers()
    #         else:
    #             value = obj.prettyOut(obj)

    #         self._info('OID %s has value %s' % (utils.format_oid(oid), value))
    #         value_list.append(value)

    #     return value_list      
#majingwei 2018/10/12
                 
    def _get_with_error_status(self, oid, idx=(0,), expect_display_string=False):

        if self._active_connection is None:
            raise RuntimeError('No transport host set')

        idx = utils.parse_idx(idx)
        oid = utils.parse_oid(oid) + idx

        error_indication, error, _, var = \
            self._active_connection.cmd_gen.getCmd(
                self._active_connection.authentication_data,
                self._active_connection.transport_target,
                oid
        )

        if error_indication is not None:
            raise RuntimeError('SNMP GET failed: %s' % error_indication)
 #       if error != 0:
     #       raise RuntimeError('SNMP GET failed: %s' % error.prettyPrint())

        oid, obj = var[0]

        if isinstance(obj, rfc1905.NoSuchInstance):
            raise RuntimeError('Object with OID %s not found' %
                    utils.format_oid(oid))

        if expect_display_string:
            if not univ.OctetString().isSuperTypeOf(obj):
                raise RuntimeError('Returned value is not an octetstring')
            value = obj.prettyOut(obj)
        elif univ.OctetString().isSuperTypeOf(obj):
            value = obj.asNumbers()
        else:
            value = obj.prettyOut(obj)

        self._info('OID %s has value %s' % (utils.format_oid(oid), value))

        return value, error

    def get_with_error_by_name(self, obj_name, idx=(0,)):
        """Does a SNMP GET request for the specified 'oid'.

        The optional `idx` can be specified as tuple or as a string and
        defaults to `.0`.

        Examples:
        | ${value}=  | Get | SNMPv2-MIB::sysDescr | |
        | ${value}=  | Get | .1.3.6.1.2.1.1.1 | |
        | ${value}=  | Get | .iso.org.6.internet.2.1.1.1 | |
        | ${value}=  | Get | sysDescr | |
        | ${value}=  | Get | ifDescr | 2 |
        """
        mibViewCtl = view.MibViewController(self._active_connection.builder)
        objIdentity = ObjectIdentity(self.DTM_MIB_LIB_NAME,obj_name)
        objIdentity.resolveWithMib(mibViewCtl)
        oid = '.' +  str(objIdentity.getOid())

        return self._get_with_error_status(oid, idx)


    def get(self, oid, idx=(0,)):
        """Does a SNMP GET request for the specified 'oid'.

        The optional `idx` can be specified as tuple or as a string and
        defaults to `.0`.

        Examples:
        | ${value}=  | Get | SNMPv2-MIB::sysDescr | |
        | ${value}=  | Get | .1.3.6.1.2.1.1.1 | |
        | ${value}=  | Get | .iso.org.6.internet.2.1.1.1 | |
        | ${value}=  | Get | sysDescr | |
        | ${value}=  | Get | ifDescr | 2 |
        """
        return self._get(oid, idx)

    def get_by_name(self, obj_name, idx=(0,)):
        """Does a SNMP GET request for the specified 'obj_name'.

        The optional `idx` can be specified as tuple or as a string and
        defaults to `.0`.

        Examples:
        | ${value}=  | Get | SNMPv2-MIB::sysDescr | |
        | ${value}=  | Get | .1.3.6.1.2.1.1.1 | |
        | ${value}=  | Get | .iso.org.6.internet.2.1.1.1 | |
        | ${value}=  | Get | sysDescr | |
        | ${value}=  | Get | ifDescr | 2 |
        """
        mibViewCtl = view.MibViewController(self._active_connection.builder)
        objIdentity = ObjectIdentity(self.DTM_MIB_LIB_NAME,obj_name)
        objIdentity.resolveWithMib(mibViewCtl)
        oid = '.' +  str(objIdentity.getOid())

        return self._get(oid, idx)

    def get_display_string(self, oid, idx=(0,)):
        """Does a SNMP GET request for the specified 'oid' and convert it to
        display string.

        For more information and an example see `Get`.
        """
        return self._get(oid, idx, expect_display_string=True)

    def _set(self, *oid_values):
        for oid, value in oid_values:
            self._info('Setting OID %s to %s' % (utils.format_oid(oid), value))

        error_indication, error, _, var = \
            self._active_connection.cmd_gen.setCmd(
                self._active_connection.authentication_data,
                self._active_connection.transport_target,
                *oid_values
        )

        if error_indication is not None:
            raise RuntimeError('SNMP SET failed: %s' % error_indication)
        if error != 0:
            raise RuntimeError('SNMP SET failed: %s' % error.prettyPrint())

    def set(self, oid, value, idx=(0,)):
        """Does a SNMP SET request.

        See `Get` for more information on possible OID notations.

        Automatic converting to the SNMP type expected by the remote system is
        only supported for OIDs for which there is a MIB describing it. If you
        want to use an OID which is not described by a MIB, you'll have to use
        the `Set XXX`-keyword or `Convert To XXX`-keyword.

        The optional `idx` is appended to the OID (defaults to `.0`).

        Example:
        | Set | SNMPv2::sysDescr | New System Description |
        """

        if self._active_connection is None:
            raise RuntimeError('No transport host set')

        idx = utils.parse_idx(idx)
        oid = utils.parse_oid(oid) + idx
        self._set((oid, value))

    def set_by_name(self, obj_name, value, idx=(0,)):
        """Does a SNMP SET request.

        See `Get` for more information on possible OID notations.

        Automatic converting to the SNMP type expected by the remote system is
        only supported for OIDs for which there is a MIB describing it. If you
        want to use an OID which is not described by a MIB, you'll have to use
        the `Set XXX`-keyword or `Convert To XXX`-keyword.

        The optional `idx` is appended to the OID (defaults to `.0`).

        Example:
        | Set | SNMPv2::sysDescr | New System Description |
        """

        if self._active_connection is None:
            raise RuntimeError('No transport host set')

        mibViewCtl = view.MibViewController(self._active_connection.builder)
        objIdentity = ObjectIdentity(self.DTM_MIB_LIB_NAME,obj_name)
        objIdentity.resolveWithMib(mibViewCtl)
        oid = '.' +  str(objIdentity.getOid())

        idx = utils.parse_idx(idx)
        oid = utils.parse_oid(oid) + idx
        self._set((oid, value))

    def set_many(self, *oid_value_pairs):
        """ Does a SNMP SET request with multiple values.

        Set one or more values simultaneously. See `Set` for more information
        about the OID and possible value. After each value, you can give an
        index (`idx`, see example below) which is appended to the OIDs. By
        default the index is `.0`.

        Examples:
        | Set Many | SNMPv2::sysDescr | New System Description | |
        | ...      | SNMPv2-MIB::sysName | New System Name | |
        | Set Many | IF-MIB::ifDescr | IF1 Description | idx=1 |
        | ...      | IF-MIB::ifDescr | IF2 Description | idx=2 |
        """

        if self._active_connection is None:
            raise RuntimeError('No transport host set')

        args = list(oid_value_pairs)
        oid_values = list()
        try:
            while len(args):
                oid = args.pop(0)
                value = args.pop(0)
                possible_idx = args[0] if len(args) > 0 else ''
                if possible_idx.startswith('idx='):
                    idx = args.pop(0)[4:]
                else:
                    idx = (0,)
                idx = utils.parse_idx(idx)
                oid = utils.parse_oid(oid) + idx
                oid_values.append((oid, value))
        except IndexError:
            raise RuntimeError('Invalid OID/value(/index) format')
        if len(oid_values) < 1:
            raise RuntimeError('You must specify at least one OID/value pair')

        self._set(*oid_values)

    def set_many_by_name(self, *name_value_pairs):
        """ Does a SNMP SET request with multiple values.

        Set one or more values simultaneously. See `Set` for more information
        about the OID and possible value. After each value, you can give an
        index (`idx`, see example below) which is appended to the OIDs. By
        default the index is `.0`.

        Examples:
        | Set Many | SNMPv2::sysDescr | New System Description | |
        | ...      | SNMPv2-MIB::sysName | New System Name | |
        | Set Many | IF-MIB::ifDescr | IF1 Description | idx=1 |
        | ...      | IF-MIB::ifDescr | IF2 Description | idx=2 |
        """

        if self._active_connection is None:
            raise RuntimeError('No transport host set')

        args = list(name_value_pairs)
        oid_values = list()
        try:
            while len(args):
                obj_name = args.pop(0)
                mibViewCtl = view.MibViewController(self._active_connection.builder)
                objIdentity = ObjectIdentity(self.DTM_MIB_LIB_NAME,obj_name)
                objIdentity.resolveWithMib(mibViewCtl)
                oid = '.' +  str(objIdentity.getOid())
                value = args.pop(0)
                possible_idx = args[0] if len(args) > 0 else ''
                if possible_idx.startswith('idx='):
                    idx = args.pop(0)[4:]
                else:
                    idx = (0,)
                idx = utils.parse_idx(idx)
                oid = utils.parse_oid(oid) + idx
                oid_values.append((oid, value))
        except IndexError:
            raise RuntimeError('Invalid Object Name/value(/index) format')
        if len(oid_values) < 1:
            raise RuntimeError('You must specify at least one Object Name/value pair')

        self._set(*oid_values)

    def walk(self, oid):
        """Does a SNMP WALK request and returns the result as OID list."""

        if self._active_connection is None:
            raise RuntimeError('No transport host set')

        self._info('Walk starts at OID %s' % (oid, ))
        oid = utils.parse_oid(oid)

        error_indication, error, _, var_bind_table = \
            self._active_connection.cmd_gen.nextCmd(
                self._active_connection.authentication_data,
                self._active_connection.transport_target,
                oid
        )

        if error_indication:
            raise RuntimeError('SNMP WALK failed: %s' % error_indication)
        if error != 0:
            raise RuntimeError('SNMP WALK failed: %s' % error.prettyPrint())

        oids = list()
        for var_bind_table_row in var_bind_table:
            oid, obj = var_bind_table_row[0]
            oid = ''.join(('.', str(oid)))
            if obj.isSuperTypeOf(rfc1902.ObjectIdentifier()):
                obj = ''.join(('.', str(obj)))
            else:
                obj = obj.prettyOut(obj)
            self._info('%s: %s' % (oid, obj))
            oids.append((oid, obj))
        self._info(oids)
        return oids

    def prefetch_oid_table(self, oid):
        """Prefetch the walk result of the given oid.

        Subsequent calls to the `Find OID By Value` keyword will use the
        prefetched result.
        """

        oids = self.walk(oid)
        self._active_connection.prefetched_table[oid] = oids

    def find_oid_by_value(self, oid, value, strip=False):
        """Return the first OID that matches a value in a list."""

        if self._active_connection.prefetched_table.has_key(oid):
            oids = self._active_connection.prefetched_table[oid]
        else:
            oids = self.walk(oid)

        for oid in oids:
            s = str(oid[1])
            if strip is True:
                s = s.strip()
            if s == str(value):
                return oid[0]

        raise RuntimeError('Value "%s" not found.' % value)

    def find_index(self, index_length, *args):
        """Searches an index in given datasets.

        There are some SNMP tables where the index is an arbitrary one. In this
        case you have to walk through the table and find a row where some
        columns match your values.

        For example consider the following table:

        | =a= | =b= | =c= | =d= | =e= |
        |  2  |  2  |  2  |  3  |  3  |
        |  2  |  3  |  2  |  5  |  6  |

        You want to know the value of d where a is 2 and b is 3.

        | ${a}= | Walk ${oidOfA} | | | | | |
        | ${b}= | Walk ${oidOfB} | | | | | |
        | ${idx}= | Find Index | 1 | ${a} | 2 | ${b} | 3 |
        | ${valueOfD}= | Get | ${oidOfD} | index=${idx} | | | |

        The `index_length` parameter is the length of the part of the OID which
        denotes the index. Eg. if you have an OID .1.3.6.1.4.1234.1.2.3 and
        `index_length` is 2, the index would be (2,3).
        """
        if len(args) % 2 != 0:
            raise RuntimeError('Called with an invalid amount of arguments')

        data = islice(args, 0, None, 2)
        match = islice(args, 1, None, 2)

        l = list()
        for e in izip(data, match):
            # match our desired value
            d = filter(lambda x: x[1] == e[1], e[0])

            # we only need the index part of the oid
            d = map(lambda x: (utils.parse_oid(x[0])[-int(index_length):]), d)

            # now convert the list of indices to a set
            d = set(d)
            l.append(d)

        # intersect all sets
        s = set(l[0]).intersection(*l[1:])

        if len(s) == 0:
            raise RuntimeError('No index found for the given matches')
        if len(s) > 1:
            raise RuntimeError('Ambiguous match. Found %d matching indices' %
                    len(s))
        return s.pop()

    def get_index_from_oid(self, oid, length=1):
        """Return last part of oid.

        If length is 1 an integer is returned. Otherwise a tuple of integers is
        returened.

        Example:
        | ${val}= | Get Index From OID | 1.3.6.1.2.1.2.2.1.2.10102 | 1 |
        """

        length = int(length)
        oid = utils.parse_oid(oid)

        if length == 1:
            return oid[-1]
        else:
            return oid[-length:]

    def convert_to_octetstring(self, value):
        """Converts a value to a SNMP OctetString object."""
        return rfc1902.OctetString(value)

    def convert_to_integer(self, value):
        """Converts a value to a SNMP Integer object."""
        return rfc1902.Integer(value)

    def convert_to_integer32(self, value):
        """Converts a value to a SNMP Integer32 object."""
        return rfc1902.Integer32(value)

    def convert_to_counter32(self, value):
        """Converts a value to a SNMP Counter32 object."""
        return rfc1902.Counter32(value)

    def convert_to_counter64(self, value):
        """Converts a value to a SNMP Counter64 object."""
        return rfc1902.Counter64(value)

    def convert_to_gauge32(self, value):
        """Converts a value to a SNMP Gauge32 object."""
        return rfc1902.Gauge32(value)

    def convert_to_unsigned32(self, value):
        """Converts a value to a SNMP Unsigned32 object."""
        return rfc1902.Unsigned32(value)

    def convert_to_timeticks(self, value):
        """Converts a value to a SNMP TimeTicks object."""
        return rfc1902.TimeTicks(value)

    # def convert_to_ip_address(self, value):
    #     """Converts a value to a SNMP IpAddress object.

    #     See `Set IP Address` for formats which are accepted for value.
    #     """
    #     # Unfortunately, pysnmp does not support unicode strings
    #     if isinstance(value, str):
    #         value = str(value)
    #     return rfc1902.IpAddress(value)

    def set_octetstring(self, oid, value, idx=(0,)):
        """Does a SNMP SET request after converting the value to an
        OctetString SNMP Object.

        This is a convenient keyword, it does the same as a `Convert To
        OctetString` followed by a `Set`.
        """

        value = self.convert_to_octetstring(value)
        self.set(oid, value, idx)

    def set_integer(self, oid, value, idx=(0,)):
        """Does a SNMP SET request after converting the value to an
        Integer SNMP Object.

        This is a convenient keyword, it does the same as a `Convert To
        Integer` followed by a `Set`.
        """

        value = self.convert_to_integer(value)
        self.set(oid, value, idx)

    def set_integer32(self, oid, value, idx=(0,)):
        """Does a SNMP SET request after converting the value to an
        Integer32 SNMP Object.

        See also `Set Integer`.
        """

        value = self.convert_to_integer32(value)
        self.set(oid, value, idx)

    def set_counter32(self, oid, value, idx=(0,)):
        """Does a SNMP SET request after converting the value to a
        Counter32 SNMP Object.

        See also `Set Integer`.
        """

        value = self.convert_to_counter32(value)
        self.set(oid, value, idx)

    def set_counter64(self, oid, value, idx=(0,)):
        """Does a SNMP SET request after converting the value to a
        Counter64 SNMP Object.

        See also `Set Integer`.
        """

        value = self.convert_to_counter64(value)
        self.set(oid, value, idx)

    def set_gauge32(self, oid, value, idx=(0,)):
        """Does a SNMP SET request after converting the value to a
        Gauge32 SNMP Object.

        See also `Set Integer`.
        """

        value = self.convert_to_gauge32(value)
        self.set(oid, value, idx)

    def set_unsigned32(self, oid, value, idx=(0,)):
        """Does a SNMP SET request after converting the value to a
        Unsigned32 SNMP Object.

        See also `Set Integer`.
        """

        value = self.convert_to_unsigned32(value)
        self.set(oid, value, idx)

    def set_timeticks(self, oid, value, idx=(0,)):
        """Does a SNMP SET request after converting the value to a
        TimeTicks SNMP Object.

        See also `Set Integer`.
        """

        value = self.convert_to_timeticks(value)
        self.set(oid, value, idx)

    def set_ip_address(self, oid, value, idx=(0,)):
        """Does a SNMP SET request after converting the value to an
        IpAddress SNMP Object.

        The `value` can either be a string (dotted IPv4 address) or an
        iterable.

        See also `Set Integer`.

        Examples:
        | Set IP Address | ${oid} | 172.16.0.1 | | | |
        | ${myIp}= | Create List | ${172} | ${16} | ${0} | ${1} |
        | Set IP Address | ${oid} | ${myIp} | | | |
        """

        value = self.convert_to_ip_address(value)
        self.set(oid, value, idx)

    def _warn(self, msg):
        self._log(msg, 'WARN')

    def _info(self, msg):
        self._log(msg, 'INFO')

    def _debug(self, msg):
        self._log(msg, 'DEBUG')

    def _log(self, msg, level=None):
        self._is_valid_log_level(level, raise_if_invalid=True)
        msg = msg.strip()
        if level is None:
            level = self._default_log_level
        if msg != '':
            print('*%s* %s' % (level.upper(), msg))

    def _is_valid_log_level(self, level, raise_if_invalid=False):
        if level is None:
            return True
        if isinstance(level, str) and \
                level.upper() in ['TRACE', 'DEBUG', 'INFO', 'WARN', 'HTML']:
            return True
        if not raise_if_invalid:
            return False
        raise RuntimeError("Invalid log level '%s'" % level)

    def get_board_slotNo(self, rowstatus_oid, maxSlotNo):
        row_oid_list = list()
        slotNo_list = list()
        for loop in range(0, int(maxSlotNo)+1):
            error = self.get_with_errcode(str(rowstatus_oid), idx = (0, 0, int(loop)))
            if 342 != error:          
                slotNo_list.append(str(loop))

        return slotNo_list
    def get_board_of_aom_or_som(self, aom_or_som, rowstatus_oid, maxSlotNo):
        slotNo_list = self.get_board_slotNo(rowstatus_oid, maxSlotNo)
        aom_slotNo_list = list()
        som_slotNo_list = list()
        self._info('debug..........')
        for slotNo in slotNo_list:
            if int(slotNo) in (0, 1):
                aom_slotNo_list.append(str(slotNo))
            if int(slotNo) in (6, 7, 8, 9, 10, 11):
                som_slotNo_list.append(str(slotNo))
        if aom_or_som == 'aom':
            return aom_slotNo_list
        elif aom_or_som == 'som':
            return som_slotNo_list
        return 'error'

    def get_Rru_No(self, rowstatus_oid, maxRruNo):
        row_oid_list = list()
        rruNo_list = list()
        for loop in range(0, int(maxRruNo)+1):
            error = self.get_with_errcode(str(rowstatus_oid), idx = (loop))
            if 342 != error:
                rruNo_list.append(str(loop))
        return rruNo_list

    def get_topoRRUNo_Instance(self, rowstatus_oid, maxRruNo):
        rruNo_list = self.get_Rru_No(rowstatus_oid, maxRruNo)
        rru_slotNo_list = list()
        self._info('debug..........')
        for rruNo in rruNo_list:
            if int(rruNo) in (range(maxRruNo)):
                rru_slotNo_list.append(str(rruNo))
        return rru_slotNo_list

    def get_Path_No(self, rowstatus_oid, RruNo, maxPathNo):
        rruNo_list = list()
        pathNo_list = list()
        for loop_pathNo in range(1, int(maxPathNo)+1):
            error = self.get_with_errcode(str(rowstatus_oid), idx = (int(RruNo), int(loop_pathNo)))
            if 342 != error:
                pathNo_list.append(str(loop_pathNo))
        return pathNo_list

    def get_rruPathInfo(self, oid_name, rowstatus_oid, RruNo, maxPathNo):
        ret_rruPathInfo_list = list()
        get_PahtNo_list = list()
        #获取的所有RRU No的list集合
        get_pathNo_No_list = list()

        get_PahtNo_list = self.get_Path_No(rowstatus_oid, RruNo, maxPathNo)

        for pathNo in get_PahtNo_list:
            if int(pathNo) in (range(maxPathNo+1)):
                get_pathNo_No_list.append(str(pathNo))

        for pathNo in get_pathNo_No_list:
            ret_rruPathTxInfo = self.get_by_name(oid_name, idx = ((int)(RruNo), (int)(pathNo)))
            ret_rruPathInfo_list.append(ret_rruPathTxInfo)
        return ret_rruPathInfo_list

    def get_rruPathStatusByThreshold(self, oid_name, rowstatus_oid, RruNo, maxPathNo, min_value, max_value):
        rru_PathInfo_List = list()
        ret_Info_list = list()
        is_wrong_flag = 0
        tmp_RruNo = RruNo

        #获取‘射频单元编号’RruNo节点下的所有有效‘射频单元天线通道编号’
        ret_Info_list = ">>>> The rruPathRRUNo[%s], " %(int)(RruNo)

        rru_PathInfo_List = self.get_rruPathInfo(oid_name, rowstatus_oid, RruNo, maxPathNo)

        #天线通道收发方向信息
        if (oid_name == 'rruPathTxStatus' or oid_name == 'rruPathRxStatus'):
            ret_Info_list += "Following 'rruPathNo' status are FAILURE: \n"
            for index in range(1, maxPathNo):
                temp_Value = (str)(rru_PathInfo_List[index])
                if temp_Value == 'failure':
                    is_wrong_flag = 1
                    ret_Info_list += ('[' + (str)(index) + '] ')
                    if(0 == index % 10 and index != 0):
                        ret_Info_list += '\n'

        #需要根据门限值判断：天线驻波比，发送方向输出功率， 单通道上的温度               
        elif(oid_name == 'rruPathTemperature' or oid_name == 'rruPathTxPower' or oid_name == 'rruPathVSWR'):
            ret_Info_list += "Following 'rruPathNo' status are OUT OF RANGE: \n"
            for index in range(1, maxPathNo):
                temp_Value = (int)(rru_PathInfo_List[index])
                if (temp_Value > max_value) or (temp_Value < min_value):
                    is_wrong_flag = 1
                    ret_Info_list += '    rruPathNo%d,Value is %d\n' %(index, temp_Value)
        else:
            is_wrong_flag = 2
            ret_Info_list += "Input OID Name Wrong...\n" 

        if (0 == is_wrong_flag):
            ret_Info = ">>> ALL 'rruPathNo' Status are RIGHT <<<\n"
            ret_Info_list += ret_Info
            print (ret_Info)
        return ret_Info_list

#----------------rruPathTable Start----------------
    def get_rruPathRRUNo_Instence_En(self,rowstatus_oid, rruPathRRUNo_Max, rruPathNo_Max,switch):
        row_oid_list = list()
        rruPathRRUNo_list = list()
        rruPathNo_list = list()
        loop_times = 0
        rruPathNoValue_list = list()
        ret_rruRRUNo = dict()

        for loop_PathRRUNo in range(0, int(rruPathRRUNo_Max)+1):
            #rruPathNo,射频单元天线通道编号 limited 1..64
            for loop_PathNo in range(1, int(rruPathNo_Max)+1):
                error = self.get_with_errcode(str(rowstatus_oid), idx = (loop_PathRRUNo, loop_PathNo))
                if 342 != error:
                        loop_times += 1
                        rruPathNo_list.append(loop_PathNo)
                        if loop_times == 1:
                            rruPathRRUNo_list.append(loop_PathRRUNo)
            loop_times = 0
        if "rruPathRRUNo" == switch:
            return rruPathRRUNo_list
        elif "rruPathNo" == switch: 
            return rruPathNo_list
        else:
            return rruPathRRUNo_list,rruPathNo_list

    def Get_rruPathTable_Value_By_Name(self,oid, rruPathRRUNo_Max, rruPathNo_Max):
        rruPathRRUNo_En = list()
        rruPathNo_En = list()
        rruPathValue = list()

        rruPathRRUNo_En, rruPathNo_En = self.get_rruPathRRUNo_Instence_En(oid, rruPathRRUNo_Max, rruPathNo_Max,0)

        for loop_PathRRUNo in rruPathRRUNo_En:
            for loop_rruPathNo in rruPathNo_En:
                value = self.get(str(oid), idx = (loop_PathRRUNo, loop_rruPathNo))
                rruPathValue.append(value)
        return rruPathValue

    def Set_rruPathTable_Value_By_Name(self,oid,value_base,value_new,rruPathRRUNo=list(),rruPathNo=list()):
        for loop_PathRRUNo in rruPathRRUNo:
            for loop_PathNo in rruPathNo:
                ret = Get_rruPathTable_Value_Each(oid,loop_PathRRUNo,loop_PathNo)
                if  ret == value_base:
                    self.Set_rruPathTable_Value_Each(oid,value_new,loop_PathRRUNo,loop_PathNo)

    def Get_rruPathTable_Value_Each(self,oid, rruPathRRUNo,rruPathNo):
        value = self.get(str(oid),idx = (rruPathRRUNo, rruPathNo))
        return value

    def Set_rruPathTable_Value_Each(self,oid, value, rruPathRRUNo,rruPathNo):
        self.set(str(oid), value,idx = (rruPathRRUNo, rruPathNo))
#----------------rruPathTable End----------------

    def get_with_errcode(self, oid, idx=(0,), expect_display_string=False):

        if self._active_connection is None:
            raise RuntimeError('No transport host set')

        idx = utils.parse_idx(idx)
        oid = utils.parse_oid(oid) + idx
        self._info(str(oid))
        error_indication, error, _, var = \
            self._active_connection.cmd_gen.getCmd(
                self._active_connection.authentication_data,
                self._active_connection.transport_target,
                oid
        )
        self._info(str(oid))
        self._info(str(var))
        self._info(str(error))
        if error_indication is not None:
            raise RuntimeError('SNMP GET failed: %s' % error_indication)

        if error == 342:
            return 342
        if error != 0:
            raise RuntimeError('SNMP GET failed: %s' % error.prettyPrint())

        oid, obj = var[0]

        if isinstance(obj, rfc1905.NoSuchInstance):
            raise RuntimeError('Object with OID %s not found' %
                    utils.format_oid(oid))

        if expect_display_string:
            if not univ.OctetString().isSuperTypeOf(obj):
                raise RuntimeError('Returned value is not an octetstring')
            value = obj.prettyOut(obj)
        elif univ.OctetString().isSuperTypeOf(obj):
            value = obj.asNumbers()
        else:
            value = obj.prettyOut(obj)

        self._info('OID %s has value %s' % (utils.format_oid(oid), value))

        return value
    def get_singleIdx_in_gnb(self, entry_oid, maxSingleIdxNo):
        '''return single index list'''
        singleIdx_list = list()
        for idx_loop in range(0,int(maxSingleIdxNo)):
            #self._info(str(self.walk(str(entry_oid) + '.1')))
            rowstatus_oid = str(entry_oid) + '.6'
            self._info(rowstatus_oid)
            error = self.get_with_errcode(str(rowstatus_oid))#idx = (int(idx_loop),
            if 342 != error:          
                singleIdx_list.append(str(idx_loop))
        return singleIdx_list

    def get_until_createGo(self, oid, idx=(0,)):
        seconds_counter = 0
        while True:
            try:
                if 342 == self.get_with_errcode(oid, idx, False):
                    time.sleep(1)
                    seconds_counter = seconds_counter + 1
                else:
                    self._info('createGo time:' + str(seconds_counter) + 'S') 
                    return self.get_with_errcode(oid, idx, False)
            except RuntimeError:
                time.sleep(1)
                seconds_counter = seconds_counter + 1

    def get_until_enabled(self, oid, idx=(0,)):
        seconds_counter = 0
        while True:
            try:
                if 342 == self.get_with_errcode(oid, idx, False):
                    time.sleep(1)
                    seconds_counter = seconds_counter + 1
                elif 'enabled' == self.get_with_errcode(oid, idx, False):
                    self._info('enabled time:' + str(seconds_counter) + 'S') 
                    return self.get_with_errcode(oid, idx, False)
                else:
                    time.sleep(1)
                    seconds_counter = seconds_counter + 1
            except RuntimeError:
                time.sleep(1)
                seconds_counter = seconds_counter + 1
#add by zhaobaoxin@20181119 for RRU　Access Phase
    def get_until_rru_available(self, oid, idx=(0,)):
        seconds_counter = 0
        while True:
            try:
                if 342 == self.get_with_errcode(oid, idx, False):
                    time.sleep(1)
                    seconds_counter = seconds_counter + 1
                elif 'available' == self.get_with_errcode(oid, idx, False):
                    self._info('enabled time:' + str(seconds_counter) + 'S') 
                    return self.get_with_errcode(oid, idx, False)
                else:
                    time.sleep(1)
                    seconds_counter = seconds_counter + 1
            except RuntimeError:
                time.sleep(1)
                seconds_counter = seconds_counter + 1

    def get_CellIDList(self, rowstatus_oid, maxCellID):
        cellId_list = list()
        for loop in range(0, int(maxCellID)+1):
            error = self.get_with_errcode(str(rowstatus_oid), idx=int(loop))
            if 342 != error:          
                cellId_list.append(str(loop))
        return cellId_list
#plp0 is disabled when no clk mode
    def is_fpga_plp0(idx):
        sub_idx = idx.split('.')
        if 4 != len(sub_idx):
            self._info(idx)
            raise RuntimeError('SNMP GET failed: %s' % error.prettyPrint())
        else:
            if '1' == sub_idx[-1] and 5 < int(sub_idx[-2]):
                return True
        return False


    def get_until_enabled_for_processors(self, oid, idx=(0,)):
        seconds_counter = 0
        while True:
            try:
                if 342 == self.get_with_errcode(oid, idx, False):
                    time.sleep(1)
                    seconds_counter = seconds_counter + 1
                elif 'disabled' == self.get_with_errcode(oid, idx, False) and \
                    True == self.is_fpga_plp0(str(idx)):
                    self._info('disabled time:' + str(seconds_counter) + 'S') 
                    return self.get_with_errcode(oid, idx, False)
                elif 'enabled' == self.get_with_errcode(oid, idx, False):
                    self._info('enabled time:' + str(seconds_counter) + 'S') 
                    return self.get_with_errcode(oid, idx, False)
                else:
                    time.sleep(1)
                    seconds_counter = seconds_counter + 1
            except RuntimeError:
                time.sleep(1)
                seconds_counter = seconds_counter + 1


    def create_folder_by_current_time(self, basePath, timeStr):
        timeStr = ''.join(timeStr.split('-'))
        timeStr = ''.join(timeStr.split())
        timeStr = ''.join(timeStr.split(':'))
        timeStr = ''.join(timeStr.split('.'))
        folderpath = str(basePath) + '\\' + timeStr.strip(':')
        isExists = os.makedirs(folderpath)
        print(isExists)
        return folderpath

#Merge by zhaobaoxin@20181127 from dev_python36 Created by FYF
    def get_next(self, oid):
        """Does a SNMP GET-NEXT request and returns the result as OID list."""

        if self._active_connection is None:
            raise RuntimeError('No transport host set')

        self._info('GET-NEXT starts at OID %s' % (oid, ))
        oid = utils.parse_oid(oid)
        self._info("This is a test after oid = utils.parse_oid(oid)")
        error_indication, error, _, var_bind_table = \
            self._active_connection.cmd_gen.nextOneCmd(
                self._active_connection.authentication_data,
                self._active_connection.transport_target,
                oid
        )

        if error_indication:
            raise RuntimeError('SNMP GET-NEXT 1 failed: %s' % error_indication)
        if error != 0:
            if error == 13:
                return ()
            else:
                raise RuntimeError('SNMP GET-NEXT 2 failed: %s' % error.prettyPrint())
        
        vbTuple = ()
        for var_bind_table_row in var_bind_table:
            oid, obj = var_bind_table_row[0]
            oid = ''.join(('.', str(oid)))
            if obj.isSuperTypeOf(rfc1902.ObjectIdentifier()):
                obj = ''.join(('.', str(obj)))
            else:
                obj = obj.prettyOut(obj)
            self._info('%s: %s' % (oid, obj))
            vbTuple = (oid, obj)

        return vbTuple
