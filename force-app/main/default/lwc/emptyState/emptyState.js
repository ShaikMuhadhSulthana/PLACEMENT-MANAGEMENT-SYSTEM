import { LightningElement, api } from 'lwc';

export default class EmptyState extends LightningElement {

    @api title = 'No Data Available';

    @api message = 'There is currently no information to display.';

    @api actionLabel;

    get showAction() {
        return !!this.actionLabel;
    }

    handleAction() {

        this.dispatchEvent(
            new CustomEvent('action')
        );

    }
}