﻿
#Область ПрограммныйИнтерфейс

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	//++ Локализация
	
	МеханизмыДокумента.Добавить("ПодарочныеСертификаты");
	

	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый документ.
//  Отказ - Булево - Признак проведения документа.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то проведение документа выполнено не будет.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ОбработкаПроведения(Объект, Отказ, РежимПроведения) Экспорт

КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то будет выполнен отказ от продолжения работы после выполнения проверки заполнения.
//  ПроверяемыеРеквизиты - Массив - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	//++ Локализация
	
	Если ЗначениеЗаполнено(Объект.ДоговорЭквайринга) Тогда
		СпособПроведенияПлатежа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ДоговорЭквайринга, Метаданные.Справочники.ДоговорыЭквайринга.Реквизиты.СпособПроведенияПлатежа.Имя);
		Если СпособПроведенияПлатежа = Перечисления.СпособыПроведенияПлатежей.СистемаБыстрыхПлатежей Тогда
			ПроверяемыеРеквизиты.Добавить(Метаданные.Документы.ОперацияПоПлатежнойКарте.Реквизиты.ИдентификаторОплатыСБП.Имя);
		КонецЕсли;
	КонецЕсли;
	
	ПодарочныеСертификатыСервер.ОбработкаПроверкиЗаполнения(Объект, Отказ);
	
	//-- Локализация
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект.
//  ДанныеЗаполнения - Произвольный - Значение, которое используется как основание для заполнения.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполнения(Объект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//
Процедура ОбработкаУдаленияПроведения(Объект, Отказ) Экспорт

КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//  РежимЗаписи - РежимЗаписиДокумента - В параметр передается текущий режим записи документа. Позволяет определить в теле процедуры режим записи.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ПередЗаписью(Объект, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина, то запись выполнена не будет и будет вызвано исключение.
//
Процедура ПриЗаписи(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  ОбъектКопирования - ДокументОбъект - Исходный документ, который является источником копирования.
//
Процедура ПриКопировании(Объект, ОбъектКопирования) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
КонецПроцедуры

// Добавляет команду создания документа "Авансовый отчет".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
Процедура ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт


КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
КонецПроцедуры

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
КонецПроцедуры

#КонецОбласти


#Область Фискализация

//++ Локализация

// Возвращает параметры операции фискализации чека для печати чека по документу
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма документ, из которого печатается чек - содержит:
// 	* Объект - ДокументОбъект - Документ-объект, основной параметр формы.
// Возвращаемое значение:
// 	Структура - Структура параметров операции фискализации чека
Функция ОсновныеПараметрыОперации(Форма) Экспорт
	
	Объект = Форма.Объект;
	
	ОсновныеПараметрыОперации = ФормированиеФискальныхЧековСерверПереопределяемый.СтруктураОсновныхПараметровОперации();
	
	ОсновныеПараметрыОперации.ДокументСсылка       = Объект.Ссылка;
	ОсновныеПараметрыОперации.Организация          = Объект.Организация;
	ОсновныеПараметрыОперации.Контрагент           = Объект.Контрагент;
	ОсновныеПараметрыОперации.Партнер              = Форма.Партнер;
	ОсновныеПараметрыОперации.Валюта               = Объект.Валюта;
	ОсновныеПараметрыОперации.СуммаДокумента       = Объект.СуммаДокумента;
	
	ОсновныеПараметрыОперации.ИмяКомандыПробитияЧека         = "ПробитьЧек";
	ОсновныеПараметрыОперации.ИмяРеквизитаГиперссылкиНаФорме = "ФискальнаяОперацияСтатус";
	
	ОсновныеПараметрыОперации.ОплатаВыполнена  = Объект.ОплатаВыполнена;
	
	Если Не Объект.ОплатаВыполнена Тогда
		
		Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента Тогда
			ТипТранзакции = "AuthorizeSales";
		Иначе
			ТипТранзакции = "AuthorizeRefund";
		КонецЕсли;
		
		ПараметрыЭквайринговойОперации = Новый Структура;;
		ПараметрыЭквайринговойОперации.Вставить("Сумма",                 Объект.СуммаДокумента);
		ПараметрыЭквайринговойОперации.Вставить("ТипТранзакции",         ТипТранзакции);
		ПараметрыЭквайринговойОперации.Вставить("ЭквайринговыйТерминал", Объект.ЭквайринговыйТерминал);
	КонецЕсли;
	
	ОсновныеПараметрыОперации.ПараметрыЭквайринговойОперации = ПараметрыЭквайринговойОперации;
	
	Возврат ОсновныеПараметрыОперации;
	
КонецФункции

// Определяет, разрешено ли пробитие фискального чека по документу
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма документ, из которого печатается чек - содержит:
// 	* Объект - ДокументОбъект - Документ-объект, основной параметр формы.
// Возвращаемое значение:
// 	Булево - Истина, если разрешено пробитие чека
Функция РазрешеноПробитиеФискальныхЧековПоДокументу(Форма) Экспорт
	
	РазрешеноПробитиеФискальныхЧековПоДокументу = Истина;
	
	Возврат РазрешеноПробитиеФискальныхЧековПоДокументу;
	
КонецФункции

// Формирует массив форматированных строк для формирования гиперссылки пробития фискального чека
// 
// Параметры:
// 	ДокументСсылка - ДокументСсылка - Документ-ссылка, по которому пробивается фискальный чек
// 	Форма - ФормаКлиентскогоПриложения - Форма документ, из которого печатается чек - содержит:
// 	* Объект - ДокументОбъект - Документ-объект, основной параметр формы.
// 	МассивПредставлений - Массив из ФорматированнаяСтрока - Массив форматированных строк для формирования гиперссылки
//    пробития фискального чека.
Процедура ОбновитьГиперссылкуПробитияФискальногоЧека(ДокументСсылка, Форма, МассивПредставлений) Экспорт
	
	Объект = Форма.Объект;
	
	ФискальнаяОперацияДанныеЖурнала = ФормированиеФискальныхЧековСервер.ДанныеПробитогоФискальногоЧекаПоДокументу(ДокументСсылка);
	ФискальнаяОперацияПодключенноеОборудование = ПодключаемоеОборудованиеУТВызовСервера.ОборудованиеПодключенноеКТерминалу(Объект.ЭквайринговыйТерминал);
	
	Если НЕ Объект.ОплатаВыполнена
		И ФискальнаяОперацияДанныеЖурнала = Неопределено Тогда
		
		СпособПроведенияПлатежа = Форма.СпособПроведенияПлатежа;
		
		Если СпособПроведенияПлатежа = Перечисления.СпособыПроведенияПлатежей.ЭквайринговыйТерминал
			И (ЗначениеЗаполнено(ФискальнаяОперацияПодключенноеОборудование.Терминал) 
				Или ФискальнаяОперацияПодключенноеОборудование.ИспользоватьБезПодключенияОборудования = Истина)
			И ЗначениеЗаполнено(ФискальнаяОперацияПодключенноеОборудование.ККТ)
			И ФормированиеФискальныхЧековСервер.ЕстьПодключенноеОборудованиеККассамОрганизации(Объект.Организация) Тогда
			
			ТекстСсылки = "ПробитьЧек";
			ТекстПредставления = Неопределено;
			Если ЗначениеЗаполнено(ФискальнаяОперацияПодключенноеОборудование.Терминал) Тогда
				ТекстПредставления = НСтр("ru = 'Принять оплату и пробить чек'");
				Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту Тогда
					ТекстПредставления = НСтр("ru = 'Вернуть оплату и пробить чек'");
				КонецЕсли;							
			КонецЕсли;
			ФормированиеФискальныхЧековСервер.ДобавитьВПредставлениеГиперссылкиКомандуПробитьЧек(МассивПредставлений, ТекстСсылки, ТекстПредставления);
		
		ИначеЕсли СпособПроведенияПлатежа = Перечисления.СпособыПроведенияПлатежей.СистемаБыстрыхПлатежей
			И ФормированиеФискальныхЧековСервер.ЕстьПодключенноеОборудованиеККассамОрганизации(Объект.Организация) Тогда
			
			ТекстСсылки = "НастроитьОборудование";
			ТекстПредставления = Неопределено;
			ПараметрыНастройкиПодключения = ПараметрыНастройкиПодключения(Объект.ДоговорЭквайринга);
			Если ЗначениеЗаполнено(ПараметрыНастройкиПодключения) Тогда
				ТекстСсылки = "ПробитьЧек";
				ТекстПредставления = НСтр("ru = 'Пробить чек'");
				Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту Тогда
					ТекстПредставления = НСтр("ru = 'Вернуть оплату и пробить чек'");
				КонецЕсли;			
			КонецЕсли;
			ФормированиеФискальныхЧековСервер.ДобавитьВПредставлениеГиперссылкиКомандуПробитьЧек(МассивПредставлений, ТекстСсылки, ТекстПредставления);
			
		Иначе
			ФормированиеФискальныхЧековСервер.ДобавитьВПредставлениеГиперссылкиСтатусЧекНеПробит(МассивПредставлений, "НастроитьОборудование");
		КонецЕсли;
		
	ИначеЕсли Объект.ОплатаВыполнена
		И ФискальнаяОперацияДанныеЖурнала = Неопределено Тогда
		
		Если ФормированиеФискальныхЧековСервер.ЕстьПодключенноеОборудованиеККассамОрганизации(Объект.Организация) Тогда 
			ТекстСсылки = "ПробитьЧек";
			ТекстПредставления = НСтр("ru = 'Оплата принята, пробить чек'");
			Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту Тогда
				ТекстПредставления = НСтр("ru = 'Оплата возвращена, пробить чек'");
			КонецЕсли;			
				
			ФормированиеФискальныхЧековСервер.ДобавитьВПредставлениеГиперссылкиКомандуПробитьЧек(МассивПредставлений, ТекстСсылки, ТекстПредставления);
		Иначе
			ФормированиеФискальныхЧековСервер.ДобавитьВПредставлениеГиперссылкиСтатусЧекНеПробит(МассивПредставлений, "НастроитьОборудование");
		КонецЕсли;
		
	ИначеЕсли ФискальнаяОперацияДанныеЖурнала <> Неопределено Тогда
		
		НомерЧекаККМ = ФискальнаяОперацияДанныеЖурнала.НомерЧекаККМ;
		ТекстСсылки = "ОткрытьЗаписьФискальнойОперации";
		
		ШаблонТекстаПредставления = НСтр("ru = 'Оплата принята, пробит чек №%1'");
		Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту Тогда
			ШаблонТекстаПредставления = НСтр("ru = 'Оплата возвращена, пробит чек №%1'");
		КонецЕсли;			
		ТекстПредставления = СтрШаблон(ШаблонТекстаПредставления, НомерЧекаККМ);
		
		ФормированиеФискальныхЧековСервер.ДобавитьВПредставлениеГиперссылкиКомандуЧекПробит(МассивПредставлений, НомерЧекаККМ, ТекстСсылки, ТекстПредставления);
		
	КонецЕсли;
	
КонецПроцедуры

// Определяет виды фискальных чеков, доступных по документу
// 
// Параметры:
// 	ВидыЧеков - ТаблицаЗначений - Таблица значений, содержащая виды фискальных чеков, доступных по документу
// 	Операция - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операция по документу
// 	ИмяКомандыПробитияЧека - Строка - Имя команды пробития чека
Процедура ЗаполнитьВидыФискальныхЧековПоДокументу(ВидыЧеков, Операция, ИмяКомандыПробитияЧека) Экспорт
	
	ТипРасчетовДенежнымиСредствами = Перечисления.ТипыРасчетаДенежнымиСредствами.ПриходДенежныхСредств; // Операция = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента
	Если Операция = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту Тогда
		ТипРасчетовДенежнымиСредствами = Перечисления.ТипыРасчетаДенежнымиСредствами.ВозвратДенежныхСредств;
	КонецЕсли;
	
	ВидЧека = ВидыЧеков.Добавить();
	ВидЧека.ТипФискальногоДокумента = Перечисления.ТипыФискальныхДокументовККТ.КассовыйЧек;
	ВидЧека.ТипРасчетаДенежнымиСредствами = ТипРасчетовДенежнымиСредствами;
	ВидЧека.ВидЧекаКоррекции = Неопределено;
	
	Если ФормированиеФискальныхЧековСерверПереопределяемый.РазрешенКассовыйЧекКоррекцииДляТипаРасчетов(ТипРасчетовДенежнымиСредствами) Тогда
		ВидЧека = ВидыЧеков.Добавить();
		ВидЧека.ТипФискальногоДокумента = Перечисления.ТипыФискальныхДокументовККТ.КассовыйЧекКоррекции;
		ВидЧека.ТипРасчетаДенежнымиСредствами = ТипРасчетовДенежнымиСредствами;
		ВидЧека.ВидЧекаКоррекции = Перечисления.ВидыЧековКоррекции.НеприменениеККТ;
	КонецЕсли;
	
КонецПроцедуры

// Определяет систему налогообложения по документу
// 
// Параметры:
// 	ДокументСсылка - ДокументСсылка - Документ для определения системы налогообложения
// Возвращаемое значение:
// 	ПеречислениеСсылка.ТипыСистемНалогообложенияККТ - Система налогообложения по документу
Функция СистемаНалогообложенияПоДокументу(ДокументСсылка) Экспорт
	
	РасшифровкаПлатежа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументСсылка, "РасшифровкаПлатежа").Выгрузить();
	
	МассивОбъектовРасчетов = РасшифровкаПлатежа.ВыгрузитьКолонку("ОбъектРасчетов");
	МассивОбъектовРасчетов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(МассивОбъектовРасчетов, "НалогообложениеНДС");
	
	НалогообложениеНДСПоОбъектамРасчетов = Новый Массив();
	Для Каждого ОбъектРасчетов Из МассивОбъектовРасчетов Цикл
		
		Если ЗначениеЗаполнено(ОбъектРасчетов.Значение.НалогообложениеНДС) Тогда
			Если НалогообложениеНДСПоОбъектамРасчетов.Найти(ОбъектРасчетов.Значение.НалогообложениеНДС) = Неопределено Тогда
				НалогообложениеНДСПоОбъектамРасчетов.Добавить(ОбъектРасчетов.Значение.НалогообложениеНДС);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	СистемаНалогообложения = Неопределено;
	Если НалогообложениеНДСПоОбъектамРасчетов.Количество() = 1 Тогда
		Если НалогообложениеНДСПоОбъектамРасчетов[0] = Перечисления.ТипыНалогообложенияНДС.ПродажаПоПатенту Тогда
			СистемаНалогообложения = Перечисления.ТипыСистемНалогообложенияККТ.Патент;
		ИначеЕсли НалогообложениеНДСПоОбъектамРасчетов[0] = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД Тогда
			СистемаНалогообложения = Перечисления.ТипыСистемНалогообложенияККТ.ЕНВД;
		КонецЕсли;
	КонецЕсли;
	
	Если СистемаНалогообложения = Неопределено Тогда
		РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, "Организация");
		СистемаНалогообложения = РозничныеПродажиЛокализация.СистемаНалогообложенияФискальнойОперации(РеквизитыДокумента.Организация);
	КонецЕсли;
	
	Возврат СистемаНалогообложения;
	
КонецФункции

// Возвращает наименование клиента, кто внес или получил денежные средства в качестве аванса
// 
// Параметры:
// 	ДокументСсылка - ДокументСсылка - Документ для определения системы налогообложения
// Возвращаемое значение:
// 	Строка - Наименование клиента платежа-аванса
Функция КлиентАвансовогоПлатежаНаименование(ДокументСсылка) Экспорт
	
	Клиент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументСсылка, "Контрагент");
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Клиент, "НаименованиеПолное");
	
КонецФункции

//-- Локализация

// Управление видимостью и доступностью элементов формы документа
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - 
//
Процедура УправлениеЭлементамиФормы(Форма) Экспорт

	УстановитьВидимостьКнопкиПодбораПодарочногоСертификата(Форма);
	
	Форма.Элементы.ИдентификаторОплатыСБП.Видимость = Ложь;
	Форма.Элементы.БанкСБП.Видимость = Ложь;
	
	//++ Локализация
	
	Если Форма.СпособПроведенияПлатежа = Перечисления.СпособыПроведенияПлатежей.СистемаБыстрыхПлатежей Тогда
		
		Форма.Элементы.ИдентификаторОплатыСБП.Видимость = Истина;
		
		Форма.Элементы.ИдентификаторОплатыСБП.Доступность = Ложь;
		Форма.Элементы.ИдентификаторОплатыСБП.ТолькоПросмотр = Истина;
		Если Не ЗначениеЗаполнено(Форма.Объект.ДокументОснование) Тогда
			Форма.Элементы.ИдентификаторОплатыСБП.Доступность = Истина;
			Форма.Элементы.ИдентификаторОплатыСБП.ТолькоПросмотр = Ложь;
		КонецЕсли;
		
		Если Форма.Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту Тогда
			ЗаполнитьСписокВыбораБанкаКлиента(Форма);
			Форма.Элементы.БанкСБП.Видимость = (Форма.Элементы.БанкСБП.СписокВыбора.Количество() > 0);
		КонецЕсли;
		
	КонецЕсли;
	
	//-- Локализация

КонецПроцедуры

// Управление видимостью кнопки подбора подарочного сертификата на форме документа.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - 
//
Процедура УстановитьВидимостьКнопкиПодбораПодарочногоСертификата(Форма) Экспорт

	РазрешенаПродажаПодарочногоСертификата =
		РозничныеПродажиЛокализация.РазрешенаПродажаПодарочногоСертификатаВДокументе(Форма.Объект.ХозяйственнаяОперация);
	Форма.Элементы.РасшифровкаПлатежаПодобратьПодарочныйСертификат.Видимость = РазрешенаПродажаПодарочногоСертификата;
	
КонецПроцедуры

// Управление условным оформлением элементов формы документа.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - 
//
Процедура УстановитьУсловноеОформление(Форма) Экспорт
	
	//++ Локализация
	
	Элемент = Форма.УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Форма.Элементы.ИдентификаторОплатыСБП.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СпособПроведенияПлатежа");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение  = Перечисления.СпособыПроведенияПлатежей.СистемаБыстрыхПлатежей;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.ИдентификаторОплатыСБП");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеЗаполнено;	
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
	//
	
	Элемент = Форма.УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Форма.Элементы.ИдентификаторОплатыСБП.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СпособПроведенияПлатежа");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение  = Перечисления.СпособыПроведенияПлатежей.СистемаБыстрыхПлатежей;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.ИдентификаторОплатыСБП");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Заполнено;	
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

// Процедура дополняет тексты запросов проведения документа.
//
// Параметры:
//  Запрос - Запрос - Общий запрос проведения документа.
//  ТекстыЗапроса - СписокЗначений - Список текстов запроса проведения.
//  Регистры - Строка, Структура - Список регистров проведения документа через запятую или в ключах структуры.
//
Процедура ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры) Экспорт
	
	//++ Локализация
	
	ТекстЗапросаТаблицаАктивацияПодарочныхСертификатов(Запрос, ТекстыЗапроса, Регистры);
	

	//-- Локализация
	
КонецПроцедуры

//++ Локализация

Функция ТекстЗапросаТаблицаАктивацияПодарочныхСертификатов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "АктивацияПодарочныхСертификатов";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ОбъектыРасчетов.Объект КАК ПодарочныйСертификат,
		|	&Период КАК ДатаНачалаДействия,
		|	ВЫБОР
		|		КОГДА ВидыПодарочныхСертификатов.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.День)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, ДЕНЬ, ВидыПодарочныхСертификатов.КоличествоПериодовДействия)
		|		КОГДА ВидыПодарочныхСертификатов.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, НЕДЕЛЯ, ВидыПодарочныхСертификатов.КоличествоПериодовДействия)
		|		КОГДА ВидыПодарочныхСертификатов.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, МЕСЯЦ, ВидыПодарочныхСертификатов.КоличествоПериодовДействия)
		|		КОГДА ВидыПодарочныхСертификатов.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, КВАРТАЛ, ВидыПодарочныхСертификатов.КоличествоПериодовДействия)
		|		КОГДА ВидыПодарочныхСертификатов.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, ГОД, ВидыПодарочныхСертификатов.КоличествоПериодовДействия)
		|		КОГДА ВидыПодарочныхСертификатов.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, ДЕКАДА, ВидыПодарочныхСертификатов.КоличествоПериодовДействия)
		|		КОГДА ВидыПодарочныхСертификатов.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
		|			ТОГДА ДОБАВИТЬКДАТЕ(&Период, ПОЛУГОДИЕ, ВидыПодарочныхСертификатов.КоличествоПериодовДействия)
		|		ИНАЧЕ &Период
		|	КОНЕЦ КАК ДатаОкончанияДействия,
		|	&Организация КАК Организация		
		|ИЗ
		|	Документ.ОперацияПоПлатежнойКарте.РасшифровкаПлатежа КАК ТабличнаяЧасть
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыРасчетов КАК ОбъектыРасчетов
		|		ПО (ОбъектыРасчетов.Ссылка = ТабличнаяЧасть.ОбъектРасчетов)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыПодарочныхСертификатов КАК ВидыПодарочныхСертификатов
		|		ПО (ВидыПодарочныхСертификатов.Ссылка = ОбъектыРасчетов.Объект.Владелец)
		|ГДЕ
		|	ТабличнаяЧасть.Ссылка = &Ссылка
		|	И &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента)
		|	И ОбъектыРасчетов.Объект ССЫЛКА Справочник.ПодарочныеСертификаты";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции


//-- Локализация

#КонецОбласти

//++ Локализация

#Область ФискализацияЛокализация

Функция ПараметрыНастройкиПодключения(ДоговорПодключения, ТекстОписанияОшибки = "")
	
	ПараметрыНастройкиПодключения = Неопределено;
	
	НастройкаПодключения = РозничныеПродажиЛокализация.НастройкаПодключения(ДоговорПодключения);
	Попытка
		ПараметрыНастройкиПодключения = СистемаБыстрыхПлатежей.НастройкиПодключения(НастройкаПодключения);
	Исключение
		ТекстОписанияОшибки = ИнформацияОбОшибке().Описание;
	КонецПопытки;
 
	Если ЗначениеЗаполнено(ПараметрыНастройкиПодключения) И ПараметрыНастройкиПодключения.НастройкиСБПc2b.УчастникСБПВозврата Тогда
		ПлатежныеСистемыВозврата = ПереводыСБПc2b.УчастникиСБПДляВозврата();
		ПараметрыНастройкиПодключения.Вставить("ПлатежныеСистемыВозврата", ПлатежныеСистемыВозврата);
	КонецЕсли;
	
	Возврат ПараметрыНастройкиПодключения;
	
КонецФункции

Процедура ЗаполнитьСписокВыбораБанкаКлиента(Форма)

	Элементы = Форма.Элементы;
	Элементы.БанкСБП.СписокВыбора.Очистить();
	
	ТекстОписанияОшибки = "";
	ПараметрыНастройкиПодключения = ПараметрыНастройкиПодключения(Форма.Объект.ДоговорЭквайринга, ТекстОписанияОшибки);
	
	Если Не ЗначениеЗаполнено(ПараметрыНастройкиПодключения) Тогда
		
		Если ЗначениеЗаполнено(ТекстОписанияОшибки) Тогда
			ОбщегоНазначения.СообщитьПользователю(ТекстОписанияОшибки);
		КонецЕсли;
		
	ИначеЕсли ПараметрыНастройкиПодключения.НастройкиСБПc2b.УчастникСБПВозврата Тогда
		
		Для Каждого КлючЗначение Из ПараметрыНастройкиПодключения.ПлатежныеСистемыВозврата Цикл
			Элементы.БанкСБП.СписокВыбора.Добавить(КлючЗначение.Ключ, КлючЗначение.Значение);
			Элементы.БанкСБП.СписокВыбора.СортироватьПоПредставлению();
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

//-- Локализация

#КонецОбласти
