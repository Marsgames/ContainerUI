import Foundation

extension CLI
{
    enum RegistryCommand: ICLICommand
    {
        case login(server: String, username: String, password: String)
        case logout(server: String)
        case inspectDefault

        var arguments: [String]
        {
            switch self
            {
                case .login(let server, let username, _):
                    return ["registry", "login", "--username", username, "--password-stdin", server]
                case .logout(let server):
                    return ["registry", "logout", server]
                case .inspectDefault:
                    return ["registry", "default", "inspect"]
            }
        }

        var name: String
        {
            switch self
            {
                case .login(let server, _, _):  return "container registry login \(server)"
                case .logout(let server):       return "container registry logout \(server)"
                case .inspectDefault:           return "container registry default inspect"
            }
        }

        /// Password to pipe to stdin, when applicable.
        var stdinInput: String?
        {
            if case .login(_, _, let password) = self { return password }
            return nil
        }
    }
}
