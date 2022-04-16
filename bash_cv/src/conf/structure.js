import summary from '../files/jobs/summary'
import main from '../files/README.md';

export const structure = {
    'bin': {
        'bash': { binary: true},
    },
    'home': {
        'guest': {
            '.bashrc': { content: 'export PATH=$PATH:/home/guest' },
            'jobs': {
                'summary.out': { content: summary }
            },
            'README.md': {content: main},
        }
    },
    'mnt': {},
    'usr': {
        'bin': {
            'cat': { binary: true},
            'ls': { binary: true},
        }
    },
    'var': {
        'log': {}
    }
};
