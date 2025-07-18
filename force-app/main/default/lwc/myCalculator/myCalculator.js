import { LightningElement , track} from 'lwc';

export default class MyCalculator extends LightningElement {
    @track displayValue = '0';
    rows = [
        ['7', '8', '9', '*'],
        ['4', '5', '6', '-'],
        ['1', '2', '3', '+'],
        ['Clr', '0', '=', '/']
    ];

    handleClick(event) {
        const value = event.target.value;
         switch (value) {
            case 'Clr':
                this.displayValue = '0';
                break;
            case '=':
                this.evaluateExpression();
                break;
            default:
                if (this.displayValue === '0' && /\d/.test(value)) {
                    this.displayValue = value;
                } else {
                    this.displayValue += value;
                }
        }
    }

    evaluateExpression() {
        try {
            const expr = this.displayValue
                .replace(/×/g, '*')
                .replace(/÷/g, '/');
            this.displayValue = String(eval(expr));
        } catch {
            this.displayValue = 'Error';
        }
    }
    
}
