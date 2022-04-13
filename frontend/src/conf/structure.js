import summary from '../files/jobs/summary'
import main from '../files/main';

export const structure = {
    'home': {
      'guest': {
        '.bashrc': { content: 'export PATH=$PATH:/home/guest' },
        'README.md': {content: main},
        'jobs': {
            'summary.out': { content: summary }
        }
      }
    },
    'mnt': {},
    'usr': {
        'bin': {
            'ls': { binary: true},
            'cat': { binary: true},
        }
    },
    'bin': {
        'bash': { binary: true},
    }
};
