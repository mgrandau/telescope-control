from datetime import datetime

import ipywidgets as widgets
import pandas as pd


class WorkflowLogger:
    _done_button: widgets.Button
    _comment_input: widgets.Textarea
    _done_output: widgets.Output = widgets.Output()
    _workflow_log: pd.DataFrame
    _step: str

    def __init__(
        self,
        step: str = "",
        workflow_log: pd.DataFrame = pd.DataFrame(columns=["Time", "Step", "Comment"]),
    ) -> None:
        self._step = step
        self._workflow_log = workflow_log
        self._done_button = widgets.Button(description="Done")
        self._comment_input = widgets.Textarea(
            description="Comments:", value="", PlaceHolder="Enter comment here"
        )
        self._done_button._click_handlers.callbacks = []
        self._done_button.on_click(self._on_done_button_clicked)

    def _on_done_button_clicked(self, *args):
        self._workflow_log.loc[len(self._workflow_log.index)] = [
            datetime.now(),
            self._step,
            self._comment_input.value,
        ]

        self._done_output.clear_output()
        with self._done_output:
            print("Last 5 log entries:")
            print(self._workflow_log.tail(5))

    def display(self) -> None:
        pass
        # display(self._comment_input, self._done_button, self._done_output)

    def get_workflow_log(self) -> pd.DataFrame:
        return self._workflow_log
