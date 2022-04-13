import { getDirectoryByPath, extractPath, appendError } from "../components/bash/util";
import * as Util from '../components/bash/util';
import { Errors } from '../components/bash//const';

export const initial_history = [
    { value: 'Welcome to Maxi\'s bash resume.' },
    { value: 'Type help to see available commands.' },
    { value: 'Check the README.md file in the home for more info.' },
    { value: '' },
];

const help = `Available commands:

System:
  ls       List files
  tree     Prints file structure
  clear    Clear stdout
  cat      Prints file content
  mkdir    Creates a directory
  rm       Removes a file or directory
  cd       Changes current working directory
  echo     Prints to stdout
  pwd      Prints current working directory
  printenv Prints environment variables
  whoami   Prints username
  hostname Prints the hostname
  man      Prints command help

Other:
  open     Open resource

Spells:
  lumos    Cast lumos spell
  nox      Cast nox spell
`

const open_man = `Usage: open [resources]

  Open external resources

Resources:
  github     Opens personal github account
  linkedin   Opens personal linkedin account
`

export const extensions = {
    help: {
        exec: ({ structure, history, cwd }) => {
            const lines = help.split('\n').map(value=>({value}))
            return { structure, cwd,
                history: history.concat(lines),
            };
        },
    },
    man: {
        exec: (state, {args}, commands) => {
            const command = args[0] || '';

            if (!command) return state
            if (!Object.keys(commands).includes(command)) return Util.appendError(state, Errors.COMMAND_NOT_FOUND, command);
            if (!commands[command]["man"]) return  { ...state, history: state.history.concat({value: "No manual available"})};

            const lines = commands[command]["man"].split('\n').map(value=>({value}))
            return { ...state, history: state.history.concat(lines)};
        },
    },
    sudo: {
        exec: ({ structure, history, cwd }) => {
            console.log(test)
            return { structure, cwd,
                history: history.concat({ value: 'Access denied.' }),
            };
        },
    },
    open: {
        exec: ({ structure, history, cwd }, { args }, commands) => {
            const resource = args[0] || '';

            if (!(["github", "linkedin", "pdf"].includes(resource))) return commands["man"].exec({ structure, history, cwd }, { args: {0: "open"} }, commands)

            const resources = {
                github: "https://github.com/MaximilianoAguirre",
                linkedin: "https://www.linkedin.com/in/maximilianoaguirre/",
                pdf: ""
            }

            window.open(resources[resource], '_blank').focus();

            return { structure, cwd, history: history.concat({ value: `Opening ${resource}...` })};
        },
        man: open_man
    },
    clear: {
        exec: ({ structure, history, cwd }) => {
            return { structure, cwd,
                history: initial_history
            };
        },
    },
    tree: {
        exec: (state, { args }) => {
            const path = args[0] || '';
            const fullPath = extractPath(path, state.cwd);
            const { err, dir } = getDirectoryByPath(state.structure, fullPath);

            if (err) return appendError(state, err, path)

            const convert = (dir) => {
                const keys = Object.keys(dir)

                return keys.map(key => {
                    const response = {}

                    response['key'] = key
                    if (!('content' in dir[key]) && !('binary' in dir[key]) && Object.keys(dir[key]).length > 0) response['children'] = convert(dir[key])

                    return response
                })
            }

            const walk = (tree) => {
                var indent = 1;

                function innerWalk(tree) {
                    tree.forEach(function(node) {
                        state.history = state.history.concat({value: `${'--' + Array(indent).join('--')} ${node.key}`})

                        if(node.children) {
                            indent ++;
                            innerWalk(node.children);
                        }
                        if(tree.indexOf(node) === tree.length - 1) {
                            indent--;
                        }
                    })
                }

                innerWalk(tree);
            }

            walk(convert(dir))

            return state
        }
    }
};