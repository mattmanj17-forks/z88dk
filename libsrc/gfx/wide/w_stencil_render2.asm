

        PUBLIC  stencil_render
        PUBLIC  _stencil_render
        PUBLIC  ___stencil_render
        EXTERN  __generic_stencil_render

        defc    stencil_render=__generic_stencil_render
        defc    _stencil_render=stencil_render
        defc    ___stencil_render=stencil_render
