   function NF90_AFUN`'(ncid, varid, values, start, count, stride, map)
     integer,                         intent( in) :: ncid, varid
     TYPE, dimension(COLONS), &
                                      intent(IN_OR_OUT) :: values
     integer, dimension(:), optional, intent( in) :: start, count, stride, map
     integer                                      :: NF90_AFUN
 
     integer, dimension(nf90_max_var_dims) :: localStart, localCount, localStride, localMap
     integer                               :: numDims, counter, shapeValues(NUMDIMS)
     integer, dimension(:), allocatable    :: defaultIntArray
 
     allocate(defaultIntArray(size(values)))
 
     ! Set local arguments to default values
     shapeValues             = shape(values)
     numDims                 = size(shapeValues)
     localStart (:         ) = 1
     localCount (:numDims  ) = shapeValues
     localCount (numDims+1:) = 1
     localStride(:         ) = 1
     localMap   (:numDims  ) = (/ 1, (product(localCount(:counter)), counter = 1, numDims - 1) /)
 
     if(present(start))  localStart (:size(start) )  = start(:)
     if(present(count))  localCount (:size(count) )  = count(:)
     if(present(stride)) localStride(:size(stride)) = stride(:)
     if(present(map))  then
       localMap   (:size(map))    = map(:)
       NF90_AFUN = &
          NF_MFUN`'(ncid, varid, localStart, localCount, localStride, localMap, defaultIntArray)
     else if(present(stride)) then
       NF90_AFUN = &
          NF_SFUN`'(ncid, varid, localStart, localCount, localStride, defaultIntArray)
     else
       NF90_AFUN = &
          NF_AFUN`'(ncid, varid, localStart, localCount, defaultIntArray)
     end if
     values(COLONS) = reshape(defaultIntArray(:), shapeValues)
     if (allocated(defaultIntArray)) deallocate(defaultIntArray)
   end function NF90_AFUN
